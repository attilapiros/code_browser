lua codebrowser = require("codebrowser")

command! SaveAsGithubLink :lua codebrowser.save_file_position_as_link_to_clipboard()
command! -nargs=1 OpenCodeAt :lua codebrowser.open_code_at(<f-args>) 
