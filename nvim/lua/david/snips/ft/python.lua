return {
  ls.parser.parse_snippet("def", "def $1($2):\n    $0"),
  ls.parser.parse_snippet({trig="try",wordTrig=false},"try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}$0"),
  ls.parser.parse_snippet("impl", "import matplotlib.pyplot as plt")
}
