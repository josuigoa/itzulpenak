import os
import dialog

[inline]
fn game_names() []string {
	return ['Celeste', 'celeste']
}

fn (mut app App) install_translation() {
	app.message = '- [${app.install_path}] bidean instalatzen.\n'
	content_path := '${app.install_path}/Content/Dialog'
	dialog_path := '${content_path}/euskara.txt'
	icon_path := '${content_path}/Icons/euskara.png'

	text := $embed_file('euskara.txt').to_string()
	app.message += '- [${dialog_path}] direktorioak euskara.txt fitxategia idazten\n'
	os.write_file(dialog_path, text) or {
		eprintln('[${dialog_path}] fitxategia idaztean errorea: ${err}')
		dialog.message('[${dialog_path}] fitxategia idaztean errorea: [${err}]', buttons: .ok)
		return
	}

	icon := $embed_file('euskara.png').to_string()
	app.message += '- [${icon_path}] direktorioak euskara.png fitxategia idazten\n'
	os.write_file(icon_path, icon) or {
		eprintln('[${icon_path}] fitxategia idaztean errorea: ${err}')
		dialog.message('[${icon_path}] fitxategia idaztean errorea: [${err}]', buttons: .ok)
		return
	}

	dialog.message('Instalazioa ongi burutu da', buttons: .ok)
}
