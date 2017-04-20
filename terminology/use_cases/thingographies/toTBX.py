#!/usr/bin/env python

import os
import sys
import glob
import csv
import pandas as pd
from lxml import etree, objectify


#inpath = '../thingographies/fanzines'
#inpath = '../thingographies/grinnell'
inpath = '../thingographies/brumfield'
outpath = '../out'
filename = inpath.split('/')[-1]
outfile = outpath+'/'+filename+'.tbx.xml'

header = '''
<TEI xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:tbx="http://www.tbx.org">
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
	df = pd.read_csv(csv_path)	#, quoting=csv.QUOTE_NONE)

	# build tei structure
	root = objectify.fromstring(header)
	text = objectify.SubElement(root, 'text')
	body = objectify.SubElement(text, 'body')
	div = objectify.SubElement(body, 'div')

	# normalise whitespace + capitalisation (while preserving area codes)
	stopwords = ['THE', 'AND', 'IN', 'OUT', 'PK']
	df['Subject'] = df['Subject'].apply(lambda x: ' '.join(w.capitalize() if not w.isupper() or len(w) > 3 or w in stopwords else w for w in x.split()))
	df['Text'] = df['Text'].apply(lambda x: ' '.join(w.capitalize() if not w.isupper() or len(w) > 3 or w in stopwords else w for w in x.split()))

	# group by subject column and iterate through the csv
	subjects = df.groupby('Subject')

	stoplist = []
	i = 0

	for s, s_content in subjects:

		if s in stoplist: continue

		# look up other groups that include the current subject as 'Text'
		df_part = df[df['Text'] == s]
		synonyms = df_part['Subject'].tolist()
		stoplist += synonyms

		# start termEntry
		entry = objectify.SubElement(div, 'termEntry')
		entry.set('{http://www.w3.org/XML/1998/namespace}id', 'S'+str(i))

		# subject fields		
		for col_label in ['Category', 'Category.1']:
			cat_list = s_content[col_label].tolist() + s_content[col_label].tolist()
			categories = set([c for c in cat_list if type(c) is str])
			
			for c in categories:
				descrip = objectify.SubElement(entry, 'descrip')
				descrip._setText(c)
				descrip.set('type', 'subjectField')
				
				if col_label == 'Category':
					descrip.set('level', '1')
				else:
					descrip.set('level', '2')

		# langset + tig
		langset = objectify.SubElement(entry, 'langSet')
		langset.set('{http://www.w3.org/XML/1998/namespace}lang', 'en')

		# populate with terms
		for j, row in s_content.iterrows():
			for t in [row['Subject'], row['Text']]:
				if t not in [x.text for x in langset.xpath('./tig/*[local-name() = "term"]')]:		# see if term already exists
					tig = objectify.SubElement(langset, 'tig')
					term = objectify.SubElement(tig, '{http://www.tei-c.org/ns/1.0}term')
					term._setText(t)

					admin = objectify.SubElement(tig, 'admin')
					admin.set('type', 'source')
					admin._setText(str(row['Work_Title'])+', p.'+str(row['Page_Position']))

		# terms from synonymous groups
		for syn in synonyms:
			for j, row in subjects.get_group(syn).iterrows():
				for t in [row['Subject'], row['Text']]:
					if t not in [x.text for x in langset.xpath('./tig/*[local-name() = "term"]')]:
						tig = objectify.SubElement(langset, 'tig')
						term = objectify.SubElement(tig, '{http://www.tei-c.org/ns/1.0}term')
						term._setText(t)

						admin = objectify.SubElement(tig, 'admin')
						admin.set('type', 'source')
						admin._setText(str(row['Work_Title'])+', p.'+str(row['Page_Position']))

		i += 1


	# remove lxml annotation
	objectify.deannotate(root)
	etree.cleanup_namespaces(root)

	# create the xml string
	obj_xml = etree.tostring(root, pretty_print=True, xml_declaration=True, encoding='utf-8')

	with open(outfile, 'wb') as xml_writer:
			xml_writer.write(obj_xml)
