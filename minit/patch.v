import os

fn main() {
	orig_lines := get_file_lines('minit_loc_orig.csv')
	eu_lines := get_file_lines('minit_loc_eu.csv')

	mut patched_lines := []string{}

	for i, orig in orig_lines {
		mut line_strings := orig.split(';')
		line_strings.delete(8)
		line_strings.insert(1, eu_lines[i])
		patched_lines << line_strings.join(';')
	}

	os.write_file('minit_loc_patched.csv', patched_lines.join('\n')) or {
		eprintln('failed to write the file: ${err}')
		return
	}
}

fn get_file_lines(file_name string) []string {
	file_content := os.read_file(file_name) or {
		eprintln('failed to read the file: ${err}')
		return []
	}
	return file_content.split_into_lines()
}
