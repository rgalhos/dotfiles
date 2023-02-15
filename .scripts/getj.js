#!/usr/bin/env node
const { readFileSync, existsSync } = require('fs');
const yargs = require('yargs/yargs');

const y = yargs(process.argv.slice(2));

const SAFE_QUERY_REGEXP =
    /^([a-zç_$][\wç$]*|\[\d+\]|\['[^']+'\]|\["[^"]+"\])(\??\.[a-zç_$][\wç$]*|(\?\.)?(\[\d+\]|\['[^']+'\]|\["[^"]+"\]))*$/i;

function kill(msg, code = 1) {
	process.stderr.write(msg);
	process.exit(code);
}

y.command('unsafe', 'Execute JS code', {
        default: false,
    })
    .nargs('unsafe', 0)
    .help();

y.alias('i', 'input')
    .command('i', 'Input file')
    .nargs('i', 1)
    .help()

y.command('json', 'Print as JSON', {
        default: false
    })
    .nargs('json', 0)
    .help();

const argv = y.argv;
const unsafe = typeof argv.unsafe === 'boolean' ? argv.unsafe : false;
const forceAsJson = typeof argv.json === 'boolean' ? argv.json : false;
const input = argv.input || '/dev/stdin';
const query = argv._[0];

if (argv.input && !existsSync(argv.input)) {
    kill("invalid input file", 2);
} else if (!query) {
    kill('invalid query', 1);
} else if (!unsafe && !SAFE_QUERY_REGEXP.test(query)) {
    kill('ignoring unsafe query: use --unsafe', 3);
}

let contents;

try {
    contents = readFileSync(input, 'utf-8');
} catch {
    kill('could not open file', 4);
}

try {
    contents = JSON.parse(contents);
} catch {
    kill('invalid json', 5);
}

let result;
try {
    result = eval(`contents?.${query}`);
    if (typeof result === 'undefined') {
        kill('undefined\n', 6);
    }
} catch (e) {
    console.error(e);
    process.exit(7);
}

if (
    !forceAsJson &&
    (typeof result === 'number' ||
    typeof result === 'bigint' ||
    typeof result === 'string' ||
    typeof result === 'boolean')
) {
    process.stdout.write(String(result));
} else {
    process.stdout.write(JSON.stringify(result));
}
