import os
import ui
import gx
import dialog

[heap]
struct App {
mut:
	window       &ui.Window = unsafe { nil }
	install_path string
	message      string
}

fn main() {
	mut app := &App{}

	app.install_path = get_steam_path(game_names())
	if app.install_path == '' {
		app.install_path = get_gog_path(game_names())
	}

	$if linux {
		app.window = ui.window(
			width: 500
			height: 300
			title: '[${game_names()[0]}] euskaratzen'
			children: [
				ui.column(
					width: 200
					spacing: 13
					margin: ui.Margin{10, 10, 10, 10}
					children: [
						ui.label(
							text: '[${game_names()[0]}] jokoa euskaratzeko instalatzailea.'
							justify: ui.center_left
						),
						ui.label(
							text: 'Ondorengo bidean aurkitu da instalazioa, egiaztatu zuzena ote den.'
							justify: ui.center_left
						),
						ui.row(
							spacing: 13
							children: [
								ui.textbox(
									width: 400
									placeholder: 'Ez da instalaziorik aurkitu, idatzi zuk mesedez'
									text: &app.install_path
								),
								ui.button(
									text: 'Bilatu'
									bg_color: gx.light_gray
									radius: 5
									border_color: gx.gray
									on_click: app.find_click
								),
							]
						),
						ui.button(
							text: 'Instalatu'
							bg_color: gx.light_gray
							radius: 5
							border_color: gx.gray
							on_click: app.install_click
						),
						ui.textbox(
							text: &app.message
							width: 480
							height: 150
							is_multiline: true
							is_wordwrap: true
							read_only: true
							TextBoxStyleParams: ui.TextBoxStyleParams{
								text_color: gx.blue
							}
							justify: ui.center_left
						),
					]
				),
			]
		)
		ui.run(app.window)
	} $else {
		if app.install_path == '' {
			dialog.message('Adierazi [${game_names()[0]}] jokoaren instalazio direktorioa, faborez.')
			app.find_path()
		}
		app.do_install(true)
	}
}

fn (mut app App) find_click(btn &ui.Button) {
	app.find_path()
}

fn (mut app App) find_path() {
	selected_dir, _ := dialog.open_dir(path: app.install_path) or {
		dialog.message('Ez duzu direktoriorik aukeratu, ez da itzulpena instalatuko.')
		exit(1)
	}
	app.install_path = selected_dir
}

fn (mut app App) install_click(btn &ui.Button) {
	app.do_install(false)
}

fn (mut app App) do_install(ask bool) {
	if app.install_path == '' {
		dialog.message('Adierazi [${game_names()[0]}] jokoaren instalazio direktorioa, faborez.')
		return
	}
	if ask {
		if !dialog.message('[${game_names()[0]}] jokoaren euskaratzea hemen instalatu nahi duzu? [${app.install_path}]',
			buttons: .yes_no
		) {
			return
		}
	}
	app.install_translation()
}

fn get_steam_path(game_names []string) string {
	steam_bases := $if windows {
		['${os.getenv('%PROGRAMFILES%')}/Steam', '${os.getenv('%PROGRAMFILES(X86)%')}/Steam',
			'z:/home/deck/.steam/steam', 'z:/home/${os.getenv('%USERNAME%')}/.steam/steam']
	} $else {
		['~/.steam/steam']
	}

	mut path := ''
	mut lines := []string{}

	for game_name in game_names {
		for sb in steam_bases {
			path = apply_separator('${sb}/steamapps/common/${game_name}')

			if os.is_dir(path) {
				return path
			}

			lines = os.read_lines(apply_separator('${sb}/config/libraryfolders.vdf')) or {
				eprintln('error reading [libraryfolders.vdf]: ${err}')
				continue
			}
		}

		if lines.len == 0 {
			return ''
		}

		for l in lines {
			if l.contains('"path":') {
				base := l.normalize_tabs(2).replace('"path":', '').replace('"', '').replace(',',
					'').trim(' ')
				path = apply_separator('${base}/steamapps/common/${game_name}')
				if os.is_dir(path) {
					return path
				}
			}
		}
	}

	return ''
}

fn get_gog_path(game_names []string) string {
	gog_bases := $if windows {
		['${os.getenv('%PROGRAMFILES%')}/GOG Games',
			'${os.getenv('%PROGRAMFILES(X86)%')}/GOG Galaxy/Games']
	} $else {
		['${os.home_dir()}/GOG Games', '${os.home_dir()}/GOG Galaxy/Games']
	}

	for game_name in game_names {
		for gb in gog_bases {
			path := apply_separator('${gb}/${game_name}')

			if os.is_dir(path) {
				return path
			}
		}
	}

	return ''
}

[inline]
fn apply_separator(path string) string {
	return path.replace('/', os.path_separator)
}
