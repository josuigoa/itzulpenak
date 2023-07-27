import os
import encoding.hex

fn main() {
	binary_file := $if windows {
		'postal.exe'
	} $else {
		'postal1'
	}

	binary_file_backup := '${binary_file}_backup'
	if !os.exists(binary_file_backup) {
		println('${binary_file_backup} fitxategia sortu da, badaezpada')
		os.cp(binary_file, binary_file_backup) or {
			eprintln('failed to copy the file: ${err}')
			return
		}
	}

	mut binary_content := os.read_file(binary_file_backup) or {
		eprintln('failed to read the file: ${err}')
		return
	}
	translated_text := $embed_file('postal_strings_trans.txt').to_string()

	separator := hex.decode('00') or { panic('Errorea hex 00 dekodetzean') }.bytestr()

	for l in translated_text.split_into_lines() {
		if l.starts_with('#') {
			continue
		}

		orig_trans := l.split(';;')
		if orig_trans.len == 1 {
			continue
		}

		orig := orig_trans[0]
		trans := orig_trans[1]
		if orig.len != trans.len {
			println('[${orig}]-ren itzulpena ez dago ongi [${orig.len} / ${trans.len}]')
			continue
		}

		binary_content = binary_content.replace('${separator}${orig}${separator}', '${separator}${trans}${separator}')
	}

	println('[${binary_file}] successfully patched.')
	os.write_file(binary_file, binary_content) or {
		eprintln('failed to write the file: ${err}')
		return
	}

	translated_credits := $embed_file('credits.txt').to_string()
	os.write_file('res/credits.txt', translated_credits) or {
		eprintln('failed to write the file: ${err}')
		return
	}
	translated_realms := $embed_file('postal_plus_realms.ini').to_string()
	os.write_file('res/levels/postal_plus_realms.ini', translated_realms) or {
		eprintln('failed to write the file: ${err}')
		return
	}
}
