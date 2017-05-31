#!/usr/bin/env python

import os
import sys
import glob
import csv
import re
import pandas as pd
from lxml import etree, objectify
from tqdm import tqdm

pd.set_option('display.expand_frame_repr', False)
pd.set_option('display.max_rows', 150)

inpath = '../thingographies/fanzines'
#inpath = '../thingographies/grinnell'
#inpath = '../thingographies/brumfield'

outpath = '../out'
filename = inpath.split('/')[-1]
outfile = outpath+'/'+filename+'.tbx.xml'

header = '''
<TEI xmlns="http://www.tei-c.org/ns/1.0" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:tbx="http://www.tbx.org">
	<teiHeader>
	  <fileDesc>
		 <titleStmt>
			<title>Thingography - {0}</title>
		 </titleStmt>
		 <publicationStmt>
			<p>...</p>
		 </publicationStmt>
		 <sourceDesc>
			<p>...</p>
		 </sourceDesc>
	  </fileDesc>
	</teiHeader>
</TEI>'''.format(filename)


if __name__ == '__main__':

	# file i/o
	if not os.path.exists(outpath): os.makedirs(outpath)
	csv_path = glob.glob(inpath+'/*.csv')[0]
	df = pd.read_csv(csv_path)    #, quoting=csv.QUOTE_NONE)

	# build tei structure
	root = objectify.fromstring(header)
	text = objectify.SubElement(root, 'text')
	body = objectify.SubElement(text, 'body')
	div = objectify.SubElement(body, 'div')

	# normalise whitespace + capitalisation (while preserving area codes)
	stopwords = ['THE', 'AND', 'IN', 'OUT', 'PK', 'WAR']
	df['Subject'] = df['Subject'].apply(lambda x: ' '.join(w.capitalize() if not w.isupper() or len(w) > 3 or w in stopwords else w for w in x.split()))
	df['Text'] = df['Text'].apply(lambda x: ' '.join(w.capitalize() if not w.isupper() or len(w) > 3 or w in stopwords else w for w in x.split()))

	# group by subject column and iterate through the csv
	subjects = df.groupby('Subject')

	stoplist = []
	i = 0

	for s, s_content in tqdm(subjects):

		# clean term
		s = s.replace('\'s', '').replace('To_be_deleted', '').replace('to_be_deleted', '').replace('<sup>', '').replace('</sup>', '').replace('(?)', '').replace('<u>', '').replace('</u>', '').replace('<lb Break=\'no\'/>', '')
		
		t = s_content['Text'].tolist()[0]
		t = t.replace('\'s', '').replace('To_be_deleted', '').replace('to_be_deleted', '').replace('<sup>', '').replace('</sup>', '').replace('(?)', '').replace('<u>', '').replace('</u>', '').replace('<lb Break=\'no\'/>', '')

		if s in stoplist: continue

		# look up other groups that include the current subject or text in the 'Text' column
		pattern = ''.join(['(?=.*' + w.strip('^()[]?:') + ')' for w in s.split(' ')])
		if t not in [' ', '-']: pattern += '|' + t

		df_part = df[df['Text'].str.contains(pattern)]
		#print(s, '\n', df_part['Text'].tolist(), '\n')

		synonyms = df_part['Subject'].tolist()
		stoplist += synonyms

		# collect all synonyms and determine variants:		
		# combine current and synonym dfs
		rows = []
		for syn in synonyms:
			for j, row in subjects.get_group(syn).iterrows():
				rows.append(row)
				row['Subject'] = row['Text']	# duplicate and concat with 'Text' in place of 'Subject' column
				rows.append(row)

		if rows:
			syn_s = pd.concat(rows, axis=1)
			all_s = pd.concat([s_content, syn_s.T])
		else:
			all_s = s_content
		all_s = all_s.reset_index(drop=True)

		# sort by term string length
		ranking = all_s['Subject'].str.len().sort_values(ascending=False).index
		all_s = all_s.reindex(ranking)
		all_s = all_s.reset_index(drop=True)

		# longest form could also be a phrase/sentence
		example = ''
		example_meta = []
		if len(all_s.index) > 1:
			if len(all_s.loc[0, 'Subject']) > 60:	#len(all_s.loc[0, 'Subject']) > len(all_s.loc[1, 'Subject']) * 5
				example = all_s.loc[0, 'Subject']
				example_meta = [str(all_s.loc[0, 'Category']), str(all_s.loc[0, 'Category.1']), str(all_s.loc[0, 'Work_Title']), str(all_s.loc[0, 'Page_Position'])]

				# too greedy
				#all_s = all_s[all_s['Subject'] != example]
				#all_s = all_s.reset_index(drop=True)


		# longest string is taken to be the full form
		lemma = all_s.loc[0, 'Subject']
		lemma = re.sub('[\^\[\]:]', '', lemma)
		lemma = lemma.replace('\'s', '').replace('To_be_deleted', '').replace('to_be_deleted', '').replace('<sup>', '').replace('</sup>', '').replace('(?)', '').replace('<u>', '').replace('</u>', '').replace('<lb Break=\'no\'/>', '')

		lemma_meta = [str(all_s.loc[0, 'Category']), str(all_s.loc[0, 'Category.1']), str(all_s.loc[0, 'Work_Title']), str(all_s.loc[0, 'Page_Position'])]
		all_s.drop(0, inplace=True)

		if lemma not in [x.text for x in div.xpath('//orth')] and lemma not in [x.text for x in div.xpath('//orth/*')]:
		#if lemma not in [x.text for x in langsec.xpath('./tei:form/*[local-name() = "term"]', namespaces={'tei':'http://www.tei-c.org/ns/1.0'})]:
			
			# start termEntry
			#entry = objectify.SubElement(div, 'conceptEntry', nsmap={None: "http://www.tbx.org"})
			entry = objectify.SubElement(div, 'conceptEntry')
			entry.set('{http://www.w3.org/XML/1998/namespace}id', 'S'+str(i))

			# subject fields
			for syn in synonyms:
				for j, row in subjects.get_group(syn).iterrows():
					cat_list = [row['Category'], row['Category.1']]
					categories = set([c for c in cat_list if type(c) is str])
					
					for c in categories:
						if c not in [x.text for x in entry.xpath('./subjectField')]:
							descrip = objectify.SubElement(entry, 'subjectField')
							descrip._setText(c)
							#descrip.set('type', 'subjectField')

			# start langsec
			langsec = objectify.SubElement(entry, 'langSec')
			langsec.set('{http://www.w3.org/XML/1998/namespace}lang', 'en')

			#termsec = objectify.SubElement(langsec, '{http://www.tei-c.org/ns/1.0}form')
			#term = objectify.SubElement(termsec, '{http://www.tei-c.org/ns/1.0}term')
			termsec = objectify.SubElement(langsec, 'form')
			termsec.set('type', 'lemma')
			
			term = objectify.SubElement(termsec, 'orth')


			# encode the categorization info in tei
			places = ['Places', 'Restaurants', 'Bars', 'Venues', 'Cities', 'Locations', 'California', 'Towns', 'Fishing Holes']
			people = ['People', 'Artists', 'Musicians', 'Actors', 'Actresses', 'Writers']
			orgs = ['Bands', 'Businesses', 'Organizations', 'Labels', 'Actresses']

			if any(x in lemma_meta[0] for x in places) or any(x in lemma_meta[1] for x in places):
				name = objectify.SubElement(term, 'placeName')
				name._setText(lemma)

			elif any(x in lemma_meta[0] for x in people) or any(x in lemma_meta[1] for x in people):
				name = objectify.SubElement(term, 'persName')
				name._setText(lemma)

			elif any(x in lemma_meta[0] for x in orgs) or any(x in lemma_meta[1] for x in orgs):
				name = objectify.SubElement(term, 'orgName')
				name._setText(lemma)

			elif any(x == 'Dates' for x in [lemma_meta[0], lemma_meta[1]]):
				name = objectify.SubElement(term, 'date')
				name._setText(lemma)

			else:
				term._setText(lemma)			


			for j, row in all_s.iterrows():
				variant = row['Subject']
				variant = re.sub('[\^\[\]:]', '', variant)
				variant = variant.replace('\'s', '').replace('To_be_deleted', '').replace('to_be_deleted', '').replace('<sup>', '').replace('</sup>', '').replace('(?)', '').replace('<u>', '').replace('</u>', '').replace('<lb Break=\'no\'/>', '')

				#if variant not in [x.text for x in termsec.xpath('./form/*[local-name() = "orth"]')]:
				if variant not in [x.text for x in termsec.xpath('//orth')] and variant not in [x.text for x in termsec.xpath('//orth/*')]:
					alt_termsec = objectify.SubElement(termsec, 'form')
					alt_termsec.set('type', 'variant')

					alt_term = objectify.SubElement(alt_termsec, 'orth')

					if any(x in str(row['Category']) for x in places) or any(x in str(row['Category.1']) for x in places):
						name = objectify.SubElement(alt_term, 'placeName')
						name._setText(variant)

					elif any(x in str(row['Category']) for x in people) or any(x in str(row['Category.1']) for x in people):
						name = objectify.SubElement(alt_term, 'persName')
						name._setText(variant)

					elif any(x == 'Dates' for x in [str(row['Category']), str(row['Category.1'])]):
						name = objectify.SubElement(alt_term, 'date')
						name._setText(variant)
					
					else:
						alt_term._setText(variant)
					
					alt_bibl = objectify.SubElement(alt_termsec, 'bibl')
					alt_bibl._setText(str(row['Work_Title']) + ', p.' + str(row['Page_Position']))


			# example sentence incl. source information
			if example != '':
				ex = objectify.SubElement(termsec, 'cit')
				ex.set('type', 'example')
				ex_q = objectify.SubElement(ex, 'quote')
				ex_q._setText(example)
				ex_bibl = objectify.SubElement(ex, 'bibl')
				ex_bibl._setText(example_meta[2] + ', p.' + example_meta[3])

			# source information for term section
			#admin = objectify.SubElement(termsec, 'admin')
			#admin.set('type', 'source')
			#admin._setText(lemma_meta[0] + ', p.' + lemma_meta[1])
			bibl = objectify.SubElement(termsec, 'bibl')
			bibl._setText(lemma_meta[2] + ', p.' + lemma_meta[3])

		i += 1


	# remove lxml annotation
	objectify.deannotate(root)

	# create the xml string
	obj_xml = etree.tostring(root, pretty_print=True, xml_declaration=True, encoding='utf-8')

	with open(outfile, 'wb') as xml_writer:
			xml_writer.write(obj_xml)
