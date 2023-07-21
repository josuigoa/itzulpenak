import os
import cli
import encoding.hex

fn main() {
	mut cmd := cli.Command{
		name: 'binary_path'
		description: 'fitxategi exekutagarria bateko testuak aldatzeko aplikazioa'
		version: '0.0.1'
		execute: cmd_func
	}
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'binary'
		abbrev: 'b'
		description: 'Fitxategiaren exekutagarriaren path-a. Esperotako formatua: lerro bakoitzean itzuli beharreko string bat'
	})
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'text'
		abbrev: 't'
		description: 'Testuen fitxategiaren path-a. Esperotako formatua: lerro bakoitzean berezko string-a eta ";;" zeinuaren ondoren itzulpena'
	})
	cmd.setup()
	cmd.parse(os.args)
}

fn cmd_func(cmd cli.Command) ! {
	binary_file := cmd.flags.get_string('binary') or {
		panic('Ez da [binary] flag-a aurkitu: ${err}')
	}
	text_file := cmd.flags.get_string('text') or { panic('Ez da [text] flag-a aurkitu: ${err}') }

	binary_file_backup := '${binary_file}_backup'
	if !os.exists(binary_file_backup) {
		os.cp(binary_file, binary_file_backup) or {
			eprintln('failed to copy the file: ${err}')
			return
		}
	}

	mut binary_content := os.read_file(binary_file_backup) or {
		eprintln('failed to read the file: ${err}')
		return
	}
	text_content := os.read_file(text_file) or {
		eprintln('failed to read the file: ${err}')
		return
	}

	separator := hex.decode('00') or { panic('Errorea hex 00 dekodetzean') }.bytestr()

	for l in text_content.split_into_lines() {
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

		// binary_content = binary_content.replace(orig, trans)
		binary_content = binary_content.replace('${separator}${orig}${separator}', '${separator}${trans}${separator}')
	}

	println('[${binary_file}] successfully patched.')
	os.write_file(binary_file, binary_content) or {
		eprintln('failed to write the file: ${err}')
		return
	}
}
