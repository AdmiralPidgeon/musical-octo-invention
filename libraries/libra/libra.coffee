## libra #######################################################################

log = console.log
clear = console.clear
table = console.table
warn = console.warn

all = (arg) -> loop yield arg; return

use = (object) -> (dict) -> (object[key] = val for own key, val of dict)

global = (arg) ->
    
    for own key, val of arg
        (warn '[global]: overwriting ' + key) if window[key]?
        window[key] = val

scope = -> arguments[0]()

libra = {}

pack = use libra

pack { all, use, global, scope }

########################################

getType = do ->
    toString = {}.toString
    (arg) -> toString.call(arg).slice(8, -1)

isType = (thing, type) -> (getType thing) is type
isString = (arg) ->  isType arg, 'String'
isNumber = (arg) -> (isType arg, 'Number') and (not isNaN arg)
isBoolean = (arg) -> isType arg, 'Boolean'
isArray = (arg) -> isType arg, 'Array'
isObject = (arg) -> isType arg, 'Object'
isFunction = (arg) -> isType arg, 'Function'
isUndefined = (arg) -> isType arg, 'Undefined'
isNull = (arg) -> isType arg, 'Null'

isBool = isBoolean
isVoid = isUndefined
isFunc = isFunction

pack { getType, isType, isString, isNumber, isBoolean,
       isArray, isObject, isFunction, isUndefined,
       isNull, isBool, isVoid, isFunc }

########################################

scope ->

    max = Math.max
    min = Math.min

    isEven = (n) -> n % 2 is 0
    isOdd = (n) -> n % 2 is not 0

    getLines = (arg) -> arg.split /\r?\n/

    zFill = (n, m) -> "#{n}".padStart m, '0'

    sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

    $ = (selector) -> document.querySelector selector
    $$ = (selector) -> document.querySelectorAll selector

    libraTest = {}

    pack { log, table, clear, max, min, isEven, isOdd,
           getLines, zFill, sleep, $, $$, libraTest }

########################################

scope ->

    # shuffles array in place
    # uses fisher yates shuffle
    # https://bost.ocks.org/mike/shuffle/

    shuffle = (array) ->
        m = array.length

        # While there remain elements to shuffle…
        while m

            # Pick a remaining element…
            i = Math.floor(random() * m--)

            # And swap it with the current element.
            [ array[m], array[i] ] = [ array[i], array[m] ]

            #t = array[m]
            #array[m] = array[i]
            #array[i] = t

        return array

    pack { shuffle }

    ## Returns a random integer between min and max.
    ## Both upper and lower bound are inclusive.
    ## Based on code from mdn and personally tested.
    randomInteger = (min, max) ->
        min = Math.ceil min
        max = Math.floor max
        randomNumber = Math.random()
        multiplier = (max - min + 1)
        result = randomNumber * multiplier + min
        return Math.floor result

    ## Returns a random float between min (inclusive)
    ## and max (exclusive). Based of code from mdn.
    randomFloat = (min, max) ->
        Math.random() * (max - min) + min

    randomElement = (array) ->
        lastIndex = array.length - 1
        array[randomInteger 0, lastIndex]

    random = (a, b) ->

        if a is undefined
            return Math.random()

        if Array.isArray a
            return randomElement a

        if b is undefined
            return randomInteger 1, a

        return randomInteger a, b

    random.int = randomInteger
    random.float = randomFloat
    random.element = randomElement

    pack { random }

########################################

scope ->

    { $ } = libra

    html = (html) ->
        window.onload = ->
            ($ 'body').innerHTML = html

    loadHTML = (html) ->
        ($ 'body').innerHTML = html

    replaceInnerHTML = (node, html) ->
        if isString node
            node = $ node
        node.innerHTML = html

    replaceHTML = (node, html) ->
        if isString node
            node = $ node
        node.outerHTML = html

    attachHTML = (node, html) ->
        if isString node
            node = $ node
        node.insertAdjacentHTML 'beforeend', html

    createTag = (tag) -> (...args) ->

        result = ['<', tag]

        if args[0] and not isString args[0]
            obj = args.shift()
            for own key, val of obj
                result.push " #{key}=\"#{val}\""

        result.push '>'
        result = result.concat args
        result.push "</#{tag}>"

        return result.join ''

    ####

    parseNode = (html) ->
        document.createRange().createContextualFragment html

    html.elements = -> buildObject html.elements.names, (arg) -> createTag arg

    html.globalize = (elements = html.elements.names) ->

        { buildObject } = libra

        if isString elements then elements = elements.split ' '
        global buildObject elements, (arg) -> createTag arg

    html.elements.names = 'base link meta style address article aside
    footer header h1 h2 h3 h4 h5 h6 hgroup main nav section blockquote
    dd div dl dt figcaption figure hr li ol p pre ul a abbr b bdi bdo
    br cite code data dfn em i kbd mark q rb rp rt rtc ruby s samp
    small span strong sub sup time u var wbr area audio img map
    track video embed iframe object param picture portal source
    svg math canvas script del ins caption col colgroup table
    tbody td tfoot th thead tr button datalist fieldset form
    input label legend meter optgroup option output progress
    select textarea details dialog menu summary slot template'
    .split(' ')

    pack { html, loadHTML, replaceInnerHTML, replaceHTML,
           attachHTML, createTag, parseNode }

########################################

scope ->

    vaultStore = (key, value) -> localStorage.setItem(key, JSON.stringify(value))
    vaultRetrieve = (key) -> JSON.parse(localStorage.getItem(key))
    vaultRemove = (key) -> localStorage.removeItem(key)
    vaultClear = -> localStorage.clear()

    vault = (key, value) ->

        if arguments.length is 0
            return localStorage

        if arguments.length is 1
            return vaultRetrieve key

        if arguments.length is 2
            return vaultStore key, value

    vault.store = vaultStore
    vault.retrieve = vaultRetrieve
    vault.set = vaultStore
    vault.get = vaultRetrieve
    vault.remove = vaultRemove
    vault.remove = vaultRemove
    vault.clear = vaultClear
    vault.empty = vaultClear

    pack { vault }

########################################

scope ->

    # repeat 5 -> ....

    repeat = (n, f) ->
        i = 0
        while i++ < n
            f i

    buildObject = (keys, func) ->
        res = {}
        for key in keys
            res[key] = func key
        return res

    pack { repeat, buildObject }

########################################

scope ->

    TCO = Symbol 'TCO'

    goto = -> [TCO, ...arguments]

    tco = (res) ->
        while true
            if (Array.isArray res) and (res[0] is TCO)
                res.shift()
                res = res.shift() ...res
            else return res

    pack { TCO, goto, tco }

    { libraTest } = libra

    count = (n) ->
        if n > 1000000
            return n
        return goto count, ++n

    count2 = (n) ->
        if n > 1000000
            return n
        return count2 ++n

    libraTest.countWithTCO = -> tco count 0

    libraTest.countWithoutTCO = -> count2 0

########################################

scope ->

    { $ } = libra

    css = (argA, argB) ->

        #log argA, argB

        if (isString argA) and (isUndefined argB)
            return css.load argA

        if (isObject argA) and (isUndefined argB)
            return css.bind argA

        'invalid css call'

    css.preprocessors = {}
    css.stylesheets = {}
    css.bindings = {}
    css.lineSep = '\n'
    css.blockSep = '\n\n'

    css.remove = (name) ->
        css.stylesheets[name].remove()

    css.get = (name) ->
        css.stylesheets[name]

    css.getCSS = (name) ->
        css.stylesheets[name].innerHTML

    css.disable = (name) ->
        css.stylesheets[name].disabled = true

    css.enable = (name) ->
        css.stylesheets[name].disabled = false

    css.load = (lssCode) ->
        [name, cssCode] = css.parse lssCode
        node = document.createElement 'style'
        node.innerHTML = cssCode
        css.stylesheets[name] = node
        ($ 'head').appendChild node
        return name

    css.preload = (lssCode) -> # maybe
        name = css.load lssCode
        css.disable name
        return name

    css.bind = (bindings) ->

        for key, val of bindings
            css.bindings[key] = val

        cssLines = [
            '/* bindings.libra.css */'
            ''
            ':root {'
        ]

        for key, val of css.bindings
            cssLines.push "    --#{key}: #{val};"
        cssLines.push '}'
        cssCode = cssLines.join '\n'

        unless css.stylesheets.bindings?
            node = document.createElement 'style'
            ($ 'head').appendChild node
            css.stylesheets.bindings = node

        css.stylesheets.bindings.innerHTML = cssCode 

        return

    css.parse = (lssCode) ->

        { getLines } = libra

        cssLines = getLines lssCode
        .map (line) -> line.trimEnd()
        .filter (line) -> line isnt ''

        blocks = buildChunks cssLines, 2

        blocks = blocks.map processBlock

        stylesheetName = 'default'
        animations = {}
        cssBlocks = []

        for block in blocks
            switch block[0][0]
                when 'NAME' then styleSheet = block[0][1]
                when 'SELECT', 'COMMENT' then cssBlocks.push block[1]
                when 'KEYFRAME'
                      name = block[0][1]
                      animations[name] ?= []
                      animations[name].push block[1]
                else log block
            #log cssBlocks, animations

        for name, states of animations
            cssBlocks.push ["@keyframes #{name} {", ...states, "}"].join css.lineSep

        cssBlocks.unshift "/* #{stylesheetName}.libra.css */"

        cssCode = cssBlocks
        .join css.blockSep
        .replaceAll ' (', ' calc('
        .replaceAll /\$([a-zA-Z0-9-_]+):/g, '--$1:'
        .replaceAll /\$([a-zA-Z0-9-_]+)/g, 'var(--$1)'

        return [stylesheetName, cssCode + '\n']

    buildChunks = (lines, levels = 1) ->

            { min } = libra

            return [] if lines.length is 0

            baseIndent = min ...(countSpaces line for line in lines)

            if (countSpaces lines[0]) isnt baseIndent
                throw 'IndentationError: first line not part of any chunk'

            chunks = []

            for line in lines
                if (countSpaces line) is baseIndent
                    chunks.push []
                chunks[chunks.length - 1].push line

            return chunks if levels is 1
            return ([[chunk[0]]].concat(buildChunks chunk[1..], levels - 1) for chunk in chunks)

    countSpaces = (line) ->
        i = 0
        while line[i] is ' '
            i++
        return i

    processBlock = (block) ->

        return [['#']] if block[0][0].startsWith '#'

        line = block[0][0]
        index = line.indexOf ' '
        if index is -1
            head = line
            tail = ''
        else
            head = line[0...index]
            tail = line[index ..].trim()

        #log head

        if head is 'NAME'
            return [[head, tail], ' ']

        if head is 'COMMENT'
            block[0] = '/* ' + tail.trim()
            block.push '*/'
            return [[head], block.join(css.lineSep).replaceAll(/\n[ ]*/g, '\n')]

        block = block.map(processLine).filter(isOnlyWhitespace)

        if head is 'SELECT'
            block[0] = "#{tail} {"
            block.push "}"
            return [[head], block.join css.lineSep]

        if head is 'KEYFRAME'
            [animation, ..., percentage] = tail.split(' ')
            block[0] = "#{percentage} {"
            block.push "}"
            return [[head, animation], block.join css.lineSep]

        throw "LSS Error: block cannot start with '#{head}'"

    isOnlyWhitespace = (arg) -> arg.trim().length isnt 0

    processLine = (line) ->

        line = line
        .map processPart
        .join ' '

        return line if line.split(' ', 1)[0] in ['SELECT', 'KEYFRAME', 'NAME']

        if line.startsWith '#'
            return ' '
            #line = line.replaceAll('#', '').trim()
            #return "/ * #{line} * /"

        return (preprocessLine line).split('\n').map(translateLine).join(css.lineSep)

    preprocessLine = (line) ->
        # helper for css.parse

        # get first word of line

        index = line.indexOf ' '
        if index is -1 then index = line.length

        # if first line has preprocessor registered, use it.
        # otherwise, return line unchanged.

        preprocFunc = css.preprocessors[line.substring 0, index] 

        if isFunction preprocFunc
        then return preprocFunc line
        else return line

    translateLine = (line) ->

        index = line.indexOf ' '
        if index is -1
            return line + ':;'
        head = line[0...index]
        tail = line[index ..]
        return "#{head}:#{tail};"

    processPart = (part) ->

        part.trim()

    pack { css }

########################################

scope ->

    { css } = libra

    css.preprocessors.bg = (arg) -> arg.replace 'bg', 'background'

########################################

scope ->

    bytesToHex = (bytes) ->

        if isType bytes, "ArrayBuffer"
            bytes = new Uint8Array bytes 

        if isType bytes, 'Uint8Array'
            bytes = Array.from bytes

        return bytes.map (byte) -> byte.toString(16).padStart(2, '0')
                    .join('')

    hexToBytes = (hex) ->
        (parseInt hex[i .. i + 1], 16) for _, i in hex by 2

    pack { hexToBytes, bytesToHex }

########################################

scope ->

    algoParams =

        aesCtr: ({counter} = {}) ->
            if counter
            then counter = new Uint8Array hexToBytes counter
            else counter = crypto.getRandomValues (new Uint8Array 16)
            return { name: "AES-CTR", counter, length: 64 }

    keyGenParams =

        aesCtr: { name: "AES-CTR", length: 256 }

    keyImportParams =

        aesCtr: {name: "AES-CTR"}

    encrypt = (key, message, {algorithm, mode} = {}) ->

        algorithm ?= 'aesCtr'

        key = await importKey key, ['encrypt']
        params = algoParams[algorithm]()

        if mode is 'hex'
            message = hexToBytes message

        if isString message
            message = (new TextEncoder).encode message

        if isArray message
            message = new Uint8Array message

        encryptedMessage = await crypto.subtle.encrypt params, key, message

        counter = bytesToHex params.counter
        encryptedMessage = bytesToHex encryptedMessage

        return { counter, encryptedMessage }

    decrypt = (key, data, {algorithm, mode} = {}) ->

        algorithm ?= 'aesCtr'

        key = await importKey(key, ['decrypt'])

        params = algoParams[algorithm] data

        encryptedMessage = new Uint8Array hexToBytes data.encryptedMessage

        message = await crypto.subtle.decrypt params, key, encryptedMessage

        return bytesToHex message if mode is 'hex'

        return (new TextDecoder).decode message

    generateKey = (algorithm = 'aesCtr') ->
        params = keyGenParams[algorithm]
        key = await crypto.subtle.generateKey params, true, ['encrypt']
        return exportKey key

    exportKey = (key) ->
        rawKey = await crypto.subtle.exportKey 'raw', key
        return bytesToHex rawKey

    importKey = (key, usages, algorithm = 'aesCtr') ->
        key = new Uint8Array hexToBytes key
        params = keyImportParams[algorithm]
        key = await crypto.subtle.importKey 'raw', key, params, true, usages
        return key

    digest = (message, algorithm = 'sha256') ->
        message = (new TextEncoder).encode message
        algorithm = algorithm.replace 'sha', 'SHA-'
        digested = await crypto.subtle.digest algorithm, message
        return bytesToHex digested

    window.testSecret = ->
        msg = 'test'
        key = await generateKey()
        log(key)
        encMsg = await encrypt(key, msg)
        log(encMsg)
        decMsg = await decrypt(key, encMsg)
        log(decMsg)
        msg is decMsg

    pack secret: { encrypt, decrypt, generateKey, digest }

## lock ########################################################################

########################################

scope ->

    re = /("|')((?:\\\1|(?:(?!\1).))*)\1|[\w\d-]*\(|\)|[$]?[\w\d-]+:?|[-+/*%=,;|]+/g

    tokenize = (line) ->
        res = []

        while true
            token = re.exec line
            break unless token?
            res.push token[0]

        return res

    pack { tokenize }

    t = '''fullscreen
          font bold 400px sans-serif
          display grid
          place-content center
          textClip url('../../demo/canyon.jpg')
          user-select none'''

    # console.log(tokenize(t))

    # libra.repeat 20, -> log tokenize 'fullscreen'

global libra

