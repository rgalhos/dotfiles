#!/usr/bin/env node

/**
 * This code is garbage but can get the job done
 * Will rewrite it someday
 */

const { existsSync, createReadStream } = require('fs');
const { createInterface } = require('readline');
const yargs = require('yargs/yargs');

const MATCH_COLOR = '\033[31m';

function kill(msg, code = 1) {
	process.stderr.write(msg);
	process.exit(code);
}

const y = yargs(process.argv.slice(2));

y.command('input', 'Input file')
    .nargs('input', 1)
    .help();

y.command('i', 'Case insensitive').nargs('i', 0).help()
    .command('g', 'Global').nargs('g', 0).help()
    .command('m', 'Multiline').nargs('m', 0).help()
    .command('u', 'Unicode').nargs('u', 0).help()
    .command('y', 'Sticky').nargs('y', 0).help()
    .command('s', 'Dot all').nargs('s', 0).help()
;

y.alias('k', 'keep')
    .nargs('k', 0);

y.command('color', 'Colored output (true or false)', {
        default: true,
        boolean: true
    })
    .boolean('color')
    .help();

y.command('trim', 'Trim', {
        default: false,
        boolean: true
    })
    .boolean('trim')
    .help();

y.command('test', 'Test', {
        boolean: true
    })
    .boolean('trim')
    .help();

y.command('replace', 'Replace', {
        boolean: true
    })
    .boolean('trim')
    .help();

const argv = y.argv;
const inputFile = argv.input || '/dev/stdin';
const inputExp = argv._[0];
const outputFormat = argv._[1]?.replace(/\\(\d+)/g, '$$$1');
const color = typeof argv.color === 'boolean' ? argv.color : true;
const keep = argv.keep;
const trim = argv.trim;

const isTest = argv.test;
const isReplace = argv.replace;

if (argv.input && !existsSync(argv.input)) {
    kill("invalid input file", 2);
} else if (!inputExp) {
    kill('no exp', 1);
} else if (!outputFormat && isReplace) {
    kill('invalid output format', 3);
}

let flags = '';
if (argv.i) flags += 'i';
if (argv.g) flags += 'g';
if (argv.m) flags += 'm';
if (argv.u) flags += 'u';
if (argv.y) flags += 'y';
if (argv.s) flags += 's';
flags = flags || 'gi';

let expr;
try {
    if (keep) {
        expr = new RegExp(`.*${inputExp}.*`, flags);
    } else {
        expr = new RegExp(inputExp, flags);
    }
} catch {
    kill('invalid exp', 4);
}

function replace(str) {
    const o = argv.color ? (MATCH_COLOR + outputFormat + '\033[0m') : outputFormat;
    return str.replace(expr, o);
}

function test(str) {
	if (expr.test(str)) {
        const o = color ? (MATCH_COLOR + '$1\033[0m') : '$1';
		return str.replace(new RegExp(`(${inputExp})`, flags), o);
	}
}

createInterface({
    input: createReadStream(inputFile)
}).on('line', (line) => {
	let s = '';
	if (isTest && isReplace) {
		if (expr.test(line)) {
			s = replace(line);
		} else {
			return;
		}
	} else if (isTest) {
        s = test(line);
        if (!s) return;
    } else {
        s = replace(line);
    }

	if (trim) s = s.trim();

	process.stdout.write(s + '\n');
}).on('end', () => {
	process.exit(0);
});

