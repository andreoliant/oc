<!DOCTYPE html>

<html>

<head>
<style type="text/css">
.inline {
  background-color: #f7f7f7;
  border:solid 1px #B0B0B0;
}
.error {
	font-weight: bold;
	color: #FF0000;
}
.warning {
	font-weight: bold;
}
.message {
	font-style: italic;
}
.source, .output, .warning, .error, .message {
	padding: 0 1em;
  border:solid 1px #F7F7F7;
}
.source {
  background-color: #f5f5f5;
}
.left {
  text-align: left;
}
.right {
  text-align: right;
}
.center {
  text-align: center;
}
.hl.num {
  color: #AF0F91;
}
.hl.str {
  color: #317ECC;
}
.hl.com {
  color: #AD95AF;
  font-style: italic;
}
.hl.opt {
  color: #000000;
}
.hl.std {
  color: #585858;
}
.hl.kwa {
  color: #295F94;
  font-weight: bold;
}
.hl.kwb {
  color: #B05A65;
}
.hl.kwc {
  color: #55aa55;
}
.hl.kwd {
  color: #BC5A65;
  font-weight: bold;
}
</style>

<meta charset="utf-8" />
<meta name="generator" content="pandoc" />
<meta http-equiv="X-UA-Compatible" content="IE=EDGE" />

<meta name="viewport" content="width=device-width, initial-scale=1" />

<meta name="author" content="Antonio Andreoli" />

<meta name="date" content="2021-05-31" />

<title>OpenCoesione Toolkit</title>



<style type="text/css">code{white-space: pre;}</style>
<style type="text/css" data-origin="pandoc">
a.sourceLine { display: inline-block; line-height: 1.25; }
a.sourceLine { pointer-events: none; color: inherit; text-decoration: inherit; }
a.sourceLine:empty { height: 1.2em; }
.sourceCode { overflow: visible; }
code.sourceCode { white-space: pre; position: relative; }
div.sourceCode { margin: 1em 0; }
pre.sourceCode { margin: 0; }
@media screen {
div.sourceCode { overflow: auto; }
}
@media print {
code.sourceCode { white-space: pre-wrap; }
a.sourceLine { text-indent: -1em; padding-left: 1em; }
}
pre.numberSource a.sourceLine
  { position: relative; left: -4em; }
pre.numberSource a.sourceLine::before
  { content: attr(title);
    position: relative; left: -1em; text-align: right; vertical-align: baseline;
    border: none; pointer-events: all; display: inline-block;
    -webkit-touch-callout: none; -webkit-user-select: none;
    -khtml-user-select: none; -moz-user-select: none;
    -ms-user-select: none; user-select: none;
    padding: 0 4px; width: 4em;
    color: #aaaaaa;
  }
pre.numberSource { margin-left: 3em; border-left: 1px solid #aaaaaa;  padding-left: 4px; }
div.sourceCode
  {  }
@media screen {
a.sourceLine::before { text-decoration: underline; }
}
code span.al { color: #ff0000; font-weight: bold; } /* Alert */
code span.an { color: #60a0b0; font-weight: bold; font-style: italic; } /* Annotation */
code span.at { color: #7d9029; } /* Attribute */
code span.bn { color: #40a070; } /* BaseN */
code span.bu { } /* BuiltIn */
code span.cf { color: #007020; font-weight: bold; } /* ControlFlow */
code span.ch { color: #4070a0; } /* Char */
code span.cn { color: #880000; } /* Constant */
code span.co { color: #60a0b0; font-style: italic; } /* Comment */
code span.cv { color: #60a0b0; font-weight: bold; font-style: italic; } /* CommentVar */
code span.do { color: #ba2121; font-style: italic; } /* Documentation */
code span.dt { color: #902000; } /* DataType */
code span.dv { color: #40a070; } /* DecVal */
code span.er { color: #ff0000; font-weight: bold; } /* Error */
code span.ex { } /* Extension */
code span.fl { color: #40a070; } /* Float */
code span.fu { color: #06287e; } /* Function */
code span.im { } /* Import */
code span.in { color: #60a0b0; font-weight: bold; font-style: italic; } /* Information */
code span.kw { color: #007020; font-weight: bold; } /* Keyword */
code span.op { color: #666666; } /* Operator */
code span.ot { color: #007020; } /* Other */
code span.pp { color: #bc7a00; } /* Preprocessor */
code span.sc { color: #4070a0; } /* SpecialChar */
code span.ss { color: #bb6688; } /* SpecialString */
code span.st { color: #4070a0; } /* String */
code span.va { color: #19177c; } /* Variable */
code span.vs { color: #4070a0; } /* VerbatimString */
code span.wa { color: #60a0b0; font-weight: bold; font-style: italic; } /* Warning */

</style>
<script>
// apply pandoc div.sourceCode style to pre.sourceCode instead
(function() {
  var sheets = document.styleSheets;
  for (var i = 0; i < sheets.length; i++) {
    if (sheets[i].ownerNode.dataset["origin"] !== "pandoc") continue;
    try { var rules = sheets[i].cssRules; } catch (e) { continue; }
    for (var j = 0; j < rules.length; j++) {
      var rule = rules[j];
      // check if there is a div.sourceCode rule
      if (rule.type !== rule.STYLE_RULE || rule.selectorText !== "div.sourceCode") continue;
      var style = rule.style.cssText;
      // check if color or background-color is set
      if (rule.style.color === '' && rule.style.backgroundColor === '') continue;
      // replace div.sourceCode by a pre.sourceCode rule
      sheets[i].deleteRule(j);
      sheets[i].insertRule('pre.sourceCode{' + style + '}', j);
    }
  }
})();
</script>



<style type="text/css">body {
background-color: #fff;
margin: 1em auto;
max-width: 700px;
overflow: visible;
padding-left: 2em;
padding-right: 2em;
font-family: "Open Sans", "Helvetica Neue", Helvetica, Arial, sans-serif;
font-size: 14px;
line-height: 1.35;
}
#TOC {
clear: both;
margin: 0 0 10px 10px;
padding: 4px;
width: 400px;
border: 1px solid #CCCCCC;
border-radius: 5px;
background-color: #f6f6f6;
font-size: 13px;
line-height: 1.3;
}
#TOC .toctitle {
font-weight: bold;
font-size: 15px;
margin-left: 5px;
}
#TOC ul {
padding-left: 40px;
margin-left: -1.5em;
margin-top: 5px;
margin-bottom: 5px;
}
#TOC ul ul {
margin-left: -2em;
}
#TOC li {
line-height: 16px;
}
table {
margin: 1em auto;
border-width: 1px;
border-color: #DDDDDD;
border-style: outset;
border-collapse: collapse;
}
table th {
border-width: 2px;
padding: 5px;
border-style: inset;
}
table td {
border-width: 1px;
border-style: inset;
line-height: 18px;
padding: 5px 5px;
}
table, table th, table td {
border-left-style: none;
border-right-style: none;
}
table thead, table tr.even {
background-color: #f7f7f7;
}
p {
margin: 0.5em 0;
}
blockquote {
background-color: #f6f6f6;
padding: 0.25em 0.75em;
}
hr {
border-style: solid;
border: none;
border-top: 1px solid #777;
margin: 28px 0;
}
dl {
margin-left: 0;
}
dl dd {
margin-bottom: 13px;
margin-left: 13px;
}
dl dt {
font-weight: bold;
}
ul {
margin-top: 0;
}
ul li {
list-style: circle outside;
}
ul ul {
margin-bottom: 0;
}
pre, code {
background-color: #f7f7f7;
border-radius: 3px;
color: #333;
white-space: pre-wrap; 
}
pre {
border-radius: 3px;
margin: 5px 0px 10px 0px;
padding: 10px;
}
pre:not([class]) {
background-color: #f7f7f7;
}
code {
font-family: Consolas, Monaco, 'Courier New', monospace;
font-size: 85%;
}
p > code, li > code {
padding: 2px 0px;
}
div.figure {
text-align: center;
}
img {
background-color: #FFFFFF;
padding: 2px;
border: 1px solid #DDDDDD;
border-radius: 3px;
border: 1px solid #CCCCCC;
margin: 0 5px;
}
h1 {
margin-top: 0;
font-size: 35px;
line-height: 40px;
}
h2 {
border-bottom: 4px solid #f7f7f7;
padding-top: 10px;
padding-bottom: 2px;
font-size: 145%;
}
h3 {
border-bottom: 2px solid #f7f7f7;
padding-top: 10px;
font-size: 120%;
}
h4 {
border-bottom: 1px solid #f7f7f7;
margin-left: 8px;
font-size: 105%;
}
h5, h6 {
border-bottom: 1px solid #ccc;
font-size: 105%;
}
a {
color: #0033dd;
text-decoration: none;
}
a:hover {
color: #6666ff; }
a:visited {
color: #800080; }
a:visited:hover {
color: #BB00BB; }
a[href^="http:"] {
text-decoration: underline; }
a[href^="https:"] {
text-decoration: underline; }

code > span.kw { color: #555; font-weight: bold; } 
code > span.dt { color: #902000; } 
code > span.dv { color: #40a070; } 
code > span.bn { color: #d14; } 
code > span.fl { color: #d14; } 
code > span.ch { color: #d14; } 
code > span.st { color: #d14; } 
code > span.co { color: #888888; font-style: italic; } 
code > span.ot { color: #007020; } 
code > span.al { color: #ff0000; font-weight: bold; } 
code > span.fu { color: #900; font-weight: bold; } 
code > span.er { color: #a61717; background-color: #e3d2d2; } 
</style>




</head>

<body>




<h1 class="title toc-ignore">OpenCoesione Toolkit</h1>
<h4 class="author">Antonio Andreoli</h4>
<h4 class="date">2021-05-31</h4>



<p>Il toolkit contiene funzioni per svolgere task di analisi e preparazione di reportistica tipiche del Team di OpenCoesione.</p>
<p>Potenzialmente lo strumento potrebbe essere utilizzato per l’analisi dei dati aperti pubblicati nel portale OpenCoesione, tuttavia per il momento funziona solo con dataset speciali riservati al team e disponbili in Drive.</p>
<p>Le funzioni assumono l’utilizzo delle denominazioni delle variabili in uso nel portale (vedi <a href="https://opencoesione.gov.it/media/opendata/metadati_progetti_tracciato_esteso.xls">metadati</a>) con l’eccezione di alcune variabili speciali non ancora pubblicate.</p>
<p>Il package funziona prioritariamente con la struttura della cartella ELAB di Drive, ma può anche essere configurato diversamente, anche per l’uso interamente locale.</p>
<div id="installazione" class="section level2">
<h2>Installazione</h2>
<p>Il package non è pubblicato su CRAN, va installato con una delle seguenti modalità. Dopo l’intallazione è consigliabile verificare la versione installata.</p>
<div class="sourceCode" id="cb1"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb1-1" title="1"><span class="co"># installazione da archivio disponible in locale</span></a>
<a class="sourceLine" id="cb1-2" title="2"><span class="co"># download da DRIVE &gt; TOOLS &gt; OCTK &gt; octk_X.X.X.tar.gz</span></a>
<a class="sourceLine" id="cb1-3" title="3"><span class="kw">install.packages</span>(<span class="st">&quot;path/to/local/octk_X.X.X.tar.gz&quot;</span>, <span class="dt">repos =</span> <span class="ot">NULL</span>, <span class="dt">type=</span><span class="st">&quot;source&quot;</span>)</a>
<a class="sourceLine" id="cb1-4" title="4"><span class="kw">library</span>(<span class="st">&quot;octk&quot;</span>)</a>
<a class="sourceLine" id="cb1-5" title="5"></a>
<a class="sourceLine" id="cb1-6" title="6"><span class="co"># installazione direttamente da GitHub</span></a>
<a class="sourceLine" id="cb1-7" title="7"><span class="co"># install.packages(&quot;devtools&quot;)</span></a>
<a class="sourceLine" id="cb1-8" title="8">devtools<span class="op">::</span><span class="kw">install_github</span>(<span class="st">&quot;andreoliant/oc&quot;</span>)</a>
<a class="sourceLine" id="cb1-9" title="9"><span class="kw">library</span>(<span class="st">&quot;octk&quot;</span>)</a>
<a class="sourceLine" id="cb1-10" title="10"></a>
<a class="sourceLine" id="cb1-11" title="11"><span class="co"># caricamento da sorgente</span></a>
<a class="sourceLine" id="cb1-12" title="12"><span class="co"># install.packages(&quot;devtools&quot;)</span></a>
<a class="sourceLine" id="cb1-13" title="13"><span class="co"># download da DRIVE &gt; TOOLS &gt; OCTK &gt; _src &gt; octk_X.X.X </span></a>
<a class="sourceLine" id="cb1-14" title="14">devtools<span class="op">::</span><span class="kw">load_all</span>(<span class="dt">path =</span> <span class="st">&quot;path/to/local/octk&quot;</span>)</a>
<a class="sourceLine" id="cb1-15" title="15"><span class="co"># non è necessario invocare library(&quot;octk&quot;)</span></a>
<a class="sourceLine" id="cb1-16" title="16"></a>
<a class="sourceLine" id="cb1-17" title="17"></a>
<a class="sourceLine" id="cb1-18" title="18"><span class="co"># per verificare la versione installata:</span></a>
<a class="sourceLine" id="cb1-19" title="19"><span class="kw">packageVersion</span>(<span class="st">&quot;octk&quot;</span>) <span class="co"># es. 0.4.2</span></a></code></pre></div>
</div>
<div id="dati-di-attuazione" class="section level2">
<h2>Dati di attuazione</h2>
<p>Per non gravare eccessivamente sulla banda in download e ridurre i tempi di caricamento è fortemente consigliato utilizzare una copia dei file dati disponibile in locale. In tal caso è necessario copiare i nuovi dati di ogni bimestre in un folder con la seguente struttura:</p>
<p><strong>Folder per dati OC</strong></p>
<pre><code>PATH_TO_DATI/
  BIMESTRE/ # es. &quot;20180630&quot;
    progetti_light_XXXXXXXX.csv
    operazioni_light_XXXXXXXX.csv
    ...</code></pre>
<p>I dati di attuazione specifici di un bimestre sono disponbili al percorso DRIVE &gt; DATI &gt; BIMESTRE &gt; DASAS &gt; DATAMART</p>
<p>Se si usa <em>Google Drive per desktop</em> (ex Google Drive file tream) è possibile rendere disponbile offline la cartella dati in Drive.</p>
</div>
<div id="setup-con-googledrive" class="section level2">
<h2>Setup con GoogleDrive</h2>
<p>Le elaborazioni del Team sono fatte nel drive condiviso ELAB del pertinente bimestre con la seguente struttura.</p>
<p><strong>Folder per elaborazione in Drive</strong></p>
<pre><code>BIMESTRE/
  ELAB/
    elaborazione/ # es. perimetri
      elaborazione_specifica/ # es. perimetro dissesto
        V.01/
          script_principale.R 
          script_secondario.R
          ...
          input/
          temp/
          output/
          </code></pre>
<p><em>ATTENZIONE</em>: per assicurare una buona tracciabilità, script, dati di input e file con i risultati devono essere riferiti ad una sola versione dell’elaborazione, quindi devo essere salvati dentro una cartella tipo “V.01”</p>
<p>Il setup si fa con l’apposita funzione con la seguente configurazione, che automaticamente definisce nel global environment i principali percorsi (DATA, DB, INPUT, TEMP, OUTPUT, WORK e ROOT) e, se necessario, crea le cartelle “input”, “temp” e “output”.</p>
<p>Per gli utenti già noti è implicito nel package il riferimento al percorso in cui Drive è disponbile nel file system locale.</p>
<div class="sourceCode" id="cb4"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb4-1" title="1"></a>
<a class="sourceLine" id="cb4-2" title="2"><span class="kw">library</span>(<span class="st">&quot;octk&quot;</span>)</a>
<a class="sourceLine" id="cb4-3" title="3"></a>
<a class="sourceLine" id="cb4-4" title="4"><span class="co"># setup per utenti già noti (con dati in Drive)</span></a>
<a class="sourceLine" id="cb4-5" title="5"><span class="kw">oc_init</span>(</a>
<a class="sourceLine" id="cb4-6" title="6">  <span class="dt">bimestre =</span> <span class="st">&quot;20201031&quot;</span>,</a>
<a class="sourceLine" id="cb4-7" title="7">  <span class="dt">db_ver =</span> <span class="st">&quot;20201231.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-8" title="8">  <span class="dt">elab =</span> <span class="st">&quot;elaborazione&quot;</span>,</a>
<a class="sourceLine" id="cb4-9" title="9">  <span class="dt">focus =</span> <span class="st">&quot;elaborazione_specifica&quot;</span>,</a>
<a class="sourceLine" id="cb4-10" title="10">  <span class="dt">ver =</span> <span class="st">&quot;V.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-11" title="11">  <span class="dt">use_drive =</span> <span class="ot">TRUE</span>,</a>
<a class="sourceLine" id="cb4-12" title="12">  <span class="dt">user =</span> <span class="st">&quot;Antonio&quot;</span></a>
<a class="sourceLine" id="cb4-13" title="13">)</a>
<a class="sourceLine" id="cb4-14" title="14"></a>
<a class="sourceLine" id="cb4-15" title="15"><span class="co"># setup per utenti già noti (con dati in locale)</span></a>
<a class="sourceLine" id="cb4-16" title="16"><span class="kw">oc_init</span>(</a>
<a class="sourceLine" id="cb4-17" title="17">  <span class="dt">bimestre =</span> <span class="st">&quot;20201031&quot;</span>,</a>
<a class="sourceLine" id="cb4-18" title="18">  <span class="dt">db_ver =</span> <span class="st">&quot;20201231.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-19" title="19">  <span class="dt">elab =</span> <span class="st">&quot;elaborazione&quot;</span>,</a>
<a class="sourceLine" id="cb4-20" title="20">  <span class="dt">focus =</span> <span class="st">&quot;elaborazione_specifica&quot;</span>,</a>
<a class="sourceLine" id="cb4-21" title="21">  <span class="dt">ver =</span> <span class="st">&quot;V.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-22" title="22">  <span class="dt">use_drive =</span> <span class="ot">TRUE</span>,</a>
<a class="sourceLine" id="cb4-23" title="23">  <span class="dt">user =</span> <span class="st">&quot;Antonio&quot;</span>,</a>
<a class="sourceLine" id="cb4-24" title="24">  <span class="dt">data_path =</span> <span class="st">&quot;/path/to/dati/oc&quot;</span> <span class="co"># esplicitare percorso locale</span></a>
<a class="sourceLine" id="cb4-25" title="25">)</a>
<a class="sourceLine" id="cb4-26" title="26"></a>
<a class="sourceLine" id="cb4-27" title="27"></a>
<a class="sourceLine" id="cb4-28" title="28"><span class="co"># setup per altri utenti</span></a>
<a class="sourceLine" id="cb4-29" title="29"><span class="kw">oc_init</span>(</a>
<a class="sourceLine" id="cb4-30" title="30">  <span class="dt">bimestre =</span> <span class="st">&quot;20201031&quot;</span>,</a>
<a class="sourceLine" id="cb4-31" title="31">  <span class="dt">db_ver =</span> <span class="st">&quot;20201231.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-32" title="32">  <span class="dt">elab =</span> <span class="st">&quot;elaborazione&quot;</span>,</a>
<a class="sourceLine" id="cb4-33" title="33">  <span class="dt">focus =</span> <span class="st">&quot;elaborazione_specifica&quot;</span>,</a>
<a class="sourceLine" id="cb4-34" title="34">  <span class="dt">ver =</span> <span class="st">&quot;V.01&quot;</span>,</a>
<a class="sourceLine" id="cb4-35" title="35">  <span class="dt">use_drive =</span> <span class="ot">TRUE</span>,</a>
<a class="sourceLine" id="cb4-36" title="36">  <span class="dt">drive_root =</span> <span class="st">&quot;/path/to/drive/cartelle_condivise&quot;</span></a>
<a class="sourceLine" id="cb4-37" title="37">)</a></code></pre></div>
</div>
<div id="setup-locale" class="section level2">
<h2>Setup locale</h2>
<p>E’ possibile usare il package esclusivamente in locale (DA TESTARE)</p>
<div class="sourceCode" id="cb5"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb5-1" title="1"></a>
<a class="sourceLine" id="cb5-2" title="2"><span class="co"># setuplocale</span></a>
<a class="sourceLine" id="cb5-3" title="3"><span class="kw">oc_init</span>(</a>
<a class="sourceLine" id="cb5-4" title="4">  <span class="dt">bimestre =</span> <span class="st">&quot;20201031&quot;</span>,</a>
<a class="sourceLine" id="cb5-5" title="5">  <span class="dt">db_path =</span> <span class="st">&quot;/path/to/dbcoe&quot;</span></a>
<a class="sourceLine" id="cb5-6" title="6">  <span class="dt">db_ver =</span> <span class="st">&quot;20201231.01&quot;</span>,</a>
<a class="sourceLine" id="cb5-7" title="7">  <span class="dt">elab =</span> <span class="st">&quot;elaborazione&quot;</span>,</a>
<a class="sourceLine" id="cb5-8" title="8">  <span class="dt">focus =</span> <span class="st">&quot;elaborazione_specifica&quot;</span>,</a>
<a class="sourceLine" id="cb5-9" title="9">  <span class="dt">ver =</span> <span class="st">&quot;V.01&quot;</span>,</a>
<a class="sourceLine" id="cb5-10" title="10">  <span class="dt">data_path =</span> <span class="st">&quot;/path/to/dati/oc&quot;</span>,</a>
<a class="sourceLine" id="cb5-11" title="11">  <span class="dt">use_drive =</span> <span class="ot">TRUE</span>,</a>
<a class="sourceLine" id="cb5-12" title="12">  <span class="dt">drive_root =</span> <span class="st">&quot;/path/to/drive/cartelle_condivise&quot;</span></a>
<a class="sourceLine" id="cb5-13" title="13">)</a></code></pre></div>
</div>
<div id="versioni" class="section level2">
<h2>Versioni</h2>
<p>Al momento è programmato un rilascio del package in corrispondenza di goni rilascio dei dati di attuazione, con numerazione sequenziale. In caso di necessità sono effettuati rilasci intermedi per la correzione di bug o implementazione di evolutive. Ogni rilascio è accompagnato da una mail esplicativa al Team.</p>
</div>
<div id="debug" class="section level2">
<h2>Debug</h2>
<p>Per effettuare test durante le operazioni di debug è disponbile una apposita versione del sorgente in Drive</p>
<div class="sourceCode" id="cb6"><pre class="sourceCode r"><code class="sourceCode r"><a class="sourceLine" id="cb6-1" title="1"></a>
<a class="sourceLine" id="cb6-2" title="2"><span class="co"># caricamento da sorgente NIGHTLY</span></a>
<a class="sourceLine" id="cb6-3" title="3"><span class="co"># install.packages(&quot;devtools&quot;)</span></a>
<a class="sourceLine" id="cb6-4" title="4"><span class="co"># ROOT &lt;- path/to/drive</span></a>
<a class="sourceLine" id="cb6-5" title="5">path_to_nightly &lt;-<span class="st"> </span><span class="kw">file.path</span>(ROOT, <span class="st">&quot;TOOLS&quot;</span>, <span class="st">&quot;OCTK&quot;</span>, <span class="st">&quot;_src&quot;</span>, <span class="st">&quot;_NIGHTLY&quot;</span>)</a>
<a class="sourceLine" id="cb6-6" title="6">devtools<span class="op">::</span><span class="kw">load_all</span>(<span class="dt">path =</span> path_to_nightly)</a>
<a class="sourceLine" id="cb6-7" title="7"><span class="co"># non è necessario invocare library(&quot;octk&quot;)</span></a></code></pre></div>
<p>A breve useremo github per gestire issues e nuovi sviluppi.</p>
</div>



<!-- code folding -->


<!-- dynamically load mathjax for compatibility with self-contained -->
<script>
  (function () {
    var script = document.createElement("script");
    script.type = "text/javascript";
    script.src  = "https://mathjax.rstudio.com/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML";
    document.getElementsByTagName("head")[0].appendChild(script);
  })();
</script>

</body>
</html>
