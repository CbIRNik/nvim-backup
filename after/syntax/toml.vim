" Keep TOML punctuation visible even when no Tree-sitter parser is installed.
syntax match tomlOperator /=/ display
syntax match tomlDelimiter /,/ display
syntax match tomlBracket /[][]/ contained containedin=tomlArray,tomlKeyValueArray display
