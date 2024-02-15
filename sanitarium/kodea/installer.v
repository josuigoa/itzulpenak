import os

[inline]
fn game_names() []string {
	return ['Sanitarium']
}

fn (mut app App) install_translation() {
	println('[${app.install_path}] bidean instalatzen.')
	res := $if windows {
		'${app.install_path}/data/RES.000'
	} $else {
		'${app.install_path}/game/data/RES.000'
	}

	app.message = ''
	res_backup := '${res}_backup'
	if !os.exists(res_backup) {
		println('${res_backup} fitxategia sortuko da, badaezpada')
		app.message = '${res_backup} fitxategia sortuko da, badaezpada\n'
		os.cp(res, res_backup) or {
			eprintln('Ezin izan da ${res} kopiatu: ${err}')
			app.message += '\nEzin izan da RES.000 ${res} bidera kopiatu: [${err}]\n'
			return
		}
	}

	translated_res := $embed_file('RES.000').to_string()
	app.message += '${res} fitxategia gainidazten.\n'
	os.write_file(res, translated_res) or {
		eprintln('[${res}] fitxategia idaztean errorea: ${err}')
		app.message += '\n[${res}] fitxategia idaztean errorea: [${err}]\n'
		return
	}

	println('RES.000 fitxategia [${res}] bidean gainidatzi da.')

	app.message += '\nInstalazioa ongi burutu da'
}
