return {
  ls.parser.parse_snippet("pdbg", "println!(\"{:?}\", $0);"),
  ls.parser.parse_snippet("pln", "println!(\"{}\", $0);"),
  -- ls.parser.parse_snippet({trig="try",wordTrig=false},"try:\n\t${1:pass}\nexcept ${2:Exception} as ${3:e}:\n\t${4:raise $3}$0"),
  -- ls.parser.parse_snippet("impl", "import matplotlib.pyplot as plt")
}

