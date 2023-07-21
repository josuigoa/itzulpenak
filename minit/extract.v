import os

fn main() {
	file_content := os.read_file('minit_loc_orig.csv') or {
		eprintln('failed to read the file: ${err}')
		return
	}

	orig_lines := file_content.split_into_lines()
	mut extracted := []string{}

	for orig in orig_lines {
		line_strings := orig.split(';')
		extracted << line_strings[1] // en
		// extracted << line_strings[4] // es
	}

	os.write_file('minit_loc_extracted.csv', extracted.join('\n')) or {
		eprintln('failed to write the file: ${err}')
		return
	}
}
