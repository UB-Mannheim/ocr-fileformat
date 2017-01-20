# Comparison of OCR formats

<!-- BEGIN-MARKDOWN-TOC -->
* [Format Descriptions](#format-descriptions)
	* [hOCR](#hocr)
	* [ALTO](#alto)
	* [ABBYY FineReader XML](#abbyy-finereader-xml)
* [Comparison Tables](#comparison-tables)
	* [Typographic levels](#typographic-levels)
	* [Bounding Boxes](#bounding-boxes)
	* [Hyphenation](#hyphenation)
	* [Confidence values](#confidence-values)
* [Links](#links)

<!-- END-MARKDOWN-TOC -->

## Format Descriptions

### hOCR

<!-- BEGIN-RENDER tables/versions-hocr.jade -->

<table>
  <tr>
    <th>Version</th>
    <th>Released</th>
    <th>Specs</th>
    <th>Schema</th>
    <th>Samples</th>
  </tr>
  <tr>
    <th>1.0</th>
    <td> <a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md#december-2007">December 2007</a></td>
    <td>
      <ul>
        <li><a href="https://docs.google.com/document/d/1QQnIQtvdAC_8n92-LhwPcjtAUFwBlzE8EWnKAxlgVf0/preview">Google Doc</a></li>
        <li><a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md">Github</a></li>
      </ul>
    </td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>1.1</th>
    <td> <a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md#march-2010">March 2010</a></td>
    <td>
      <ul>
        <li><a href="https://docs.google.com/document/d/1QQnIQtvdAC_8n92-LhwPcjtAUFwBlzE8EWnKAxlgVf0/preview">Google Doc</a></li>
        <li><a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md">Github</a></li>
      </ul>
    </td>
    <td>-</td>
    <td> 
      <ul>
        <li><a href="../samples/hocr/1.1/wetzel_reisebegleiter_1901_0021.hocr">[DTA]</a></li>
        <li><a href="../samples/hocr/1.1/417576986_0013.hocr">[UBMA:digi]</a></li>
      </ul>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

Smallest unit: **word**

```
<span
  class="ocrx_word"
  id="word_1_33"
  title="bbox 1584 1199 1997 1284; x_wconf 87"
  lang="deu-frak"
  dir="ltr"
  >Verhältnisse.</span>
```


### ALTO

<!-- BEGIN-RENDER tables/versions-alto.jade -->

<table>
  <tr>
    <th>Version</th>
    <th>Released</th>
    <th>Specs</th>
    <th>Schema</th>
    <th>Samples</th>
  </tr>
  <tr>
    <th>1.0</th>
    <td>December 02, 2004</td>
    <td>-</td>
    <td> <a href="https://cdn.rawgit.com/altoxml/schema/master/v1/alto-1-0.xsd">XSD</a></td>
    <td>-</td>
  </tr>
  <tr>
    <th>2.0</th>
    <td><a href="https://github.com/altoxml/schema/blob/master/v2/alto-2-0.xsd#L48">January 11, 2010</a></td>
    <td>-</td>
    <td><a href="https://cdn.rawgit.com/altoxml/schema/master/v2/alto-2-0.xsd">XSD</a></td>
    <td>
      <ul>
        <li><a href="../samples/alto/2.0/wetzel_reisebegleiter_1901_0021.alto">[DTA]</a></li>
        <li><a href="https://abbyy.technology/_media/en:features:ocr:alto_xml_sample_collection.zip">ALTO + Abbyy example</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>2.1</th>
    <td><a href="https://github.com/altoxml/schema/blob/master/v2/alto-2-1.xsd#L51">February 20, 2014</a></td>
    <td>-</td>
    <td><a href="https://cdn.rawgit.com/altoxml/schema/master/v2/alto-2-0.xsd">XSD</a></td>
    <td>
      <ul>
        <li><a href="../samples/alto/2.0/wetzel_reisebegleiter_1901_0021.alto">[DTA]</a></li>
      </ul>
    </td>
  </tr>
  <tr>
    <th>3.0</th>
    <td><a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-0.xsd#L75">August, 2014</a></td>
    <td>-</td>
    <td><a href="https://cdn.rawgit.com/altoxml/schema/master/v3/alto-3-0.xsd">XSD</a></td>
    <td>-</td>
  </tr>
  <tr>
    <th>3.1</th>
    <td><a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-1.xsd#L83">January, 2014</a></td>
    <td>-</td>
    <td><a href="https://cdn.rawgit.com/altoxml/schema/master/v3/alto-3-1.xsd">XSD</a></td>
    <td>-</td>
  </tr>
</table>

<!-- END-RENDER -->

### ABBYY FineReader XML

<!-- BEGIN-RENDER tables/versions-abbyy.jade -->

<table>
  <tr>
    <th>Version</th>
    <th>Released</th>
    <th>Specs</th>
    <th>Schema</th>
    <th>Samples</th>
  </tr>
  <tr>
    <th>6v1</th>
    <th>2002?</th>
    <td>-</td>
    <td><a href="http://fr7.abbyy.com/FineReader_xml/FineReader6-schema-v1.xml">XSD</a></td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>8v2</th>
    <th>2006?</th>
    <td>-</td>
    <td><a href="http://fr7.abbyy.com/FineReader_xml/FineReader8-schema-v2.xml">XSD</a></td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>9v1</th>
    <th>2007?</th>
    <td>-</td>
    <td><a href="http://fr7.abbyy.com/FineReader_xml/FineReader9-schema-v1.xml">XSD</a></td>
    <td>-</td>
    <td>-</td>
  </tr>
  <tr>
    <th>10v1</th>
    <th>2011?</th>
    <td> 
      <ul>
        <li><a href="https://abbyy.technology/en:features:ocr:xml">Description</a></li>
        <li><a href="https://abbyy.technology/_detail/en:features:ocr:abbyy-xml-tag-scheme-illu.png?id=en%3Afeatures%3Aocr%3Axml">Visual Overview</a></li>
      </ul>
    </td>
    <td><a href="http://fr7.abbyy.com/FineReader_xml/FineReader10-schema-v1.xml">XSD</a></td>
    <td>
      <ul>
        <li><a href="../samples/abbyy/10v1/417589220_0018.abbyy.xml">[UBMA:digi]</a></li>
        <li><a href="https://abbyy.technology/_media/en:features:ocr:alto_xml_sample_collection.zip">ALTO + Abbyy example</a></li>
      </ul>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

## Comparison Tables

### Typographic levels

<!-- BEGIN-RENDER tables/levels.jade -->

<table>
  <tr>
    <th></th>
    <th>hOCR</th>
    <th>ALTO</th>
    <th>ABBYY</th>
  </tr>
  <tr>
    <th>Page</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocr_page&quot;&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;Page&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;page&gt;</pre>
      </div>
    </td>
  </tr>
  <tr>
    <th>Text Area / Column</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocr_carea&quot;&gt;</pre>
      </div>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocrx_block&quot;&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;PrintSpace&gt;</pre>
      </div>
    </td>
  </tr>
  <tr>
    <th>Paragraph</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocr_par&quot;&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;TextBlock STYLEREFS=&quot;...&quot;&gt;</pre>
      </div>
    </td>
  </tr>
  <tr>
    <th>Text Line</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocr_line&quot;&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;TextLine&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;line&gt;
  &lt;formatting&gt;...&lt;/formatting&gt;
&lt;/line&gt;</pre>
      </div>
    </td>
  </tr>
  <tr>
    <th>Word</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div class=&quot;ocrx_word&quot;&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;TextLine&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;line&gt;
  &lt;formatting&gt;...&lt;/formatting&gt;
&lt;/line&gt;</pre>
      </div>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

### Bounding Boxes

<!-- BEGIN-RENDER tables/box-coordinates.jade -->

<table>
  <tr>
    <th>hOCR</th>
    <th>ALTO</th>
    <th>ABBYY</th>
  </tr>
  <tr>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;div title=&quot;bbox 100 200 150 250&quot;/&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;String
  HEIGHT=&quot;250&quot;
  WIDTH=&quot;150&quot;
  VPOS=&quot;100&quot;
  HPOS=&quot;200&quot;/&gt;</pre>
      </div>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;line
  l=&quot;200&quot;
  t=&quot;100&quot;
  r=&quot;1200&quot;
  b=&quot;130&quot;&gt;</pre>
      </div>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

### Hyphenation

<!-- BEGIN-RENDER tables/hyphen.jade -->

<table>
  <tr>
    <th>hOCR</th>
    <th>ALTO</th>
    <th>ABBYY</th>
  </tr>
  <tr>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&amp;shy</pre>
      </div>
      <blockquote>Soft hyphens must be represented using the HTML &shy; entity.<a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md#6-inline-representations">[1]</a></blockquote>
      <p>Regular hyphenation characters are just dashes</p>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;HYP/&gt;</pre>
      </div><a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-1.xsd#L840">[1]</a>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

### Confidence values

<!-- BEGIN-RENDER tables/confidence.jade -->

<table>
  <tr>
    <th>Level</th>
    <th>hOCR</th>
    <th>ALTO</th>
    <th>ABBYY</th>
  </tr>
  <tr>
    <th>Page</th>
    <td>-</td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;Page PC=&quot;0.743&quot;&gt;</pre>
      </div><a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-1.xsd#L207">[1]</a>
    </td>
    <td>-</td>
  </tr>
  <tr>
    <th>Word</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;span
  class=&quot;ocrx_word&quot;
  title=&quot;x_wconf 71&gt;foo&lt;/span&gt;</pre>
      </div>"if possible, convert word confidences to values between 0 and 100 and have them approximate posterior
      <probabilities>(expressed in %)"</probabilities><a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md#8-ocr-engine-specific-markup">[1]</a>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;String WC=&quot;0.422&quot;&gt;</pre>
      </div>"Word Confidence: Confidence level of the ocr for this string. A value between 0 (unsure) and 1 (sure)."<a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-1.xsd#L437">[1]</a>
    </td>
    <td>-</td>
  </tr>
  <tr>
    <th>Character</th>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;span
  class=&quot;ocrx_word&quot;
  title=&quot;x_wconf 71&gt;foo&lt;/span&gt;</pre>
      </div>
      <p>
        "if possible, convert word confidences to values between 0 and 100
        and have them approximate posterior probabilities (expressed in %)"<a href="https://github.com/kba/hocr-spec/blob/master/hocr-spec.md#8-ocr-engine-specific-markup">[1]</a>
      </p>
      <p>Not implemented in common engines?</p>
    </td>
    <td>
      <div class="highlight highlight-text-xml">
        <pre>&lt;String CC=&quot;0 0 4 0&quot; CONTENT=&quot;luft&quot;/&gt;</pre>
      </div>
      <p>"Confidence level of each character in that string. A list of numbers, one number between 0 (sure) and 9 (unsure) for each character."<a href="https://github.com/altoxml/schema/blob/master/v3/alto-3-1.xsd#L484">[1]</a></p>
    </td>
  </tr>
</table>

<!-- END-RENDER -->

## Links

* http://www.cis.lmu.de/ocrworkshop/data/slides/m6-abbyy-tesseract.pdf
