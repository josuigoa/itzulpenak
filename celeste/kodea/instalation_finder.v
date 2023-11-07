import os
import dialog

[heap]
struct App {
mut:
	install_path string
	message      string
}

fn main() {
	mut app := &App{}

	app.install_path = get_steam_path(game_names())
	if app.install_path == '' {
		app.install_path = get_gog_path(game_names())
	}

	if app.install_path == '' {
		if !dialog.message('Ez da [${game_names()[0]}] jokoaren instalazio karpetarik aurkitu. Bilatuko duzu zuk, faborez?',
			buttons: .yes_no
		) {
			return
		}
		selected_dir, _ := dialog.open_dir() or {
			dialog.message('Ez duzu direktoriorik aukeratu, ez da itzulpena instalatuko.')
			exit(1)
		}
		app.install_path = selected_dir
	}

	if !dialog.message('[${game_names()[0]}] jokoaren itzulpena instalatuko da, ados? Instalazio direktorioa: ${app.install_path}',
		buttons: .yes_no
	) {
		return
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
