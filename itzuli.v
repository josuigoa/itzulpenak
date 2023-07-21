import net.http
import json
import os
import cli
import time

struct RequestBody {
	mkey  string
	text  string
	model string
}

struct Response {
	success                 bool
	translation_error_code  int    [json: translationErrorCode]
	job_time                int    [json: jobTime]
	waiting_time            int    [json: waitingTime]
	translation_time        int    [json: translationTime]
	preprocessing_time      int    [json: preprocessingTime]
	postprocessing_time     int    [json: postprocessingTime]
	marian_translation_time int    [json: marianTranslationTime]
	user_time               int    [json: userTime]
	message                 string
	attention               string
}

fn main() {
	mut cmd := cli.Command{
		name: 'itzuli'
		description: 'euskadi.eus webguneko itzultzailea erabiltzeko comandoa'
		version: '0.0.1'
		execute: cmd_func
	}
	cmd.add_flag(cli.Flag{
		flag: .string
		required: true
		name: 'file'
		abbrev: 'p'
		description: 'Fitxategiaren path-a. Esperotako formatua: lerro bakoitzean itzuli beharreko string bat'
	})
	cmd.add_flag(cli.Flag{
		flag: .string
		required: false
		name: 'lang'
		abbrev: 'l'
		default_value: ['en']
		description: 'Zein hizkuntzatatik itzuli nahi dugun [es, en]'
	})
	cmd.setup()
	cmd.parse(os.args)
}

fn cmd_func(cmd cli.Command) ! {
	sw := time.new_stopwatch()

	file := cmd.flags.get_string('file') or { panic('Ez da [file] flag-a aurkitu: ${err}') }
	lang := cmd.flags.get_string('lang') or { panic('Ez da [lang] flag-a aurkitu: ${err}') }
	translation_type := '${lang}2eu'

	file_content := os.read_file('${file}') or {
		eprintln('[${file}] fitxategia irakurtzean errorea: ${err}')
		return
	}

	println('${time.now().hhmm()}: [${file}] fitxategiko edukia [${lang}] hizkuntzatik itzultzen')

	orig_texts := file_content.split_into_lines()
	total := orig_texts.len
	mut count := 0.0
	println('[${total}] lerro itzultzeko')
	mut translated_texts := []string{}

	for orig in orig_texts {
		translated_texts << itzuli(orig, translation_type)
		count++
		println('%${int(f32(count / total) * 100)}')
	}

	os.write_file('${file}_trans.txt', translated_texts.join('\n')) or {
		eprintln('[${file}] fitxategian idaztean errorea: ${err}')
		return
	}

	println('Itzulpena egiteko denbora: ${sw.elapsed().str()}')
}

fn itzuli(orig_text string, translation_type string) string {
	request_body := RequestBody{
		mkey: '8d9016025eb0a44215c7f69c2e10861d'
		text: orig_text
		model: 'generic_${translation_type}'
	}

	endpoint := 'https://api.euskadi.eus/itzuli/${translation_type}/translate'

	res := http.fetch(
		method: .post
		url: endpoint
		data: json.encode(request_body)
		header: http.new_header_from_map({
			http.CommonHeader.content_type:   'application/json'
			http.CommonHeader.referer:        'https://www.euskadi.eus/'
			http.CommonHeader.sec_fetch_mode: 'cors'
		})
	) or {
		panic('Itzultzaileari deitzean errorea: ${err}')
		return ''
	}

	response := json.decode(Response, res.body) or {
		panic('Itzultzailearen erantzuna irakurtzean errorea: ${err}')
		return ''
	}

	mut trans := response.message
	if trans.ends_with('.') && !orig_text.ends_with('.') {
		trans = trans.all_before_last('.')
	}
	if trans.starts_with('-') && !orig_text.starts_with('-') {
		trans = trans.all_after('-')
	}

	return trans
}
