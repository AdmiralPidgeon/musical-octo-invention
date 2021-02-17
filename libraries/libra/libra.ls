_ = window

_.log = console.log
_.clear = console.clear
_.table = console.table

_.max = Math.max
_.min = Math.min

_.isEven = -> it % 2 is 0
_.isOdd = -> it % 2 is not 0

_.getLines = -> it.split /\r?\n/

_.zFill = (n, m) -> "#{n}".padStart m, '0'

_.sleep = (ms) -> new Promise (resolve) -> setTimeout resolve, ms

$ = -> document.querySelector it
$$ = -> document.querySelectorAll it

_.$ = $
_.$$ = $$

_.libraTest = {}

#########################################

# shuffles array in place
# uses fisher yates shuffle
# https://bost.ocks.org/mike/shuffle/

_.shuffle = (array) ->
    m = array.length

    # While there remain elements to shuffle…
    while m

        # Pick a remaining element…
        i = Math.floor(Math.random() * m--)

        # And swap it with the current element.
        t = array[m]
        array[m] = array[i]
        array[i] = t

    return array

#########################################

## Returns a random integer between min and max.
## Both upper and lower bound are inclusive.
## Based on code from mdn and personally tested.
randomInteger = (min, max) ->
    min = Math.ceil min
    max = Math.floor max
    randomNumber = Math.random!
    multiplier = (max - min + 1)
    result = randomNumber * multiplier + min
    return Math.floor result

## Returns a random float between min (inclusive)
## and max (exclusive). Based of code from mdn.
randomFloat = (min, max) ->
    Math.random! * (max - min) + min

randomElement = (array) ->
    lastIndex = array.length - 1
    array[randomInteger 0, lastIndex]

_.random = (a, b) ->

    if a is undefined
        return Math.random!

    if Array.isArray a
        return randomElement a

    if b is undefined
        return randomInteger 1, a

    return randomInteger a, b

_.random.int = randomInteger
_.random.float = randomFloat
_.random.element = randomElement

#########################################

_.isType = (type, x) --> typeof! x is type ## '-->' is not a typo, it's currying
_.isString = -> typeof! it is 'String'
_.isNumber = -> (typeof! it is 'Number') and (not Number.isNaN it)
_.isBoolean = -> typeof! it is 'Boolean'
_.isBool = -> typeof! it is 'Boolean'
_.isArray = -> typeof! it is 'Array'
_.isObject = -> typeof! it is 'Object'
_.isFunction = -> typeof! it is 'Function'
_.isFunc = -> typeof! it is 'Function'
_.isUndefined = -> typeof! it is 'Undefined'
_.isVoid = -> typeof! it is 'Undefined'
_.isNull = -> typeof! it is 'Null'
_.isNaN = -> Number.isNaN it

#########################################

_.html = (html) ->
    window.onload = ->
        ($ 'body').innerHTML = html

_.loadHTML = (html) ->
    ($ 'body').innerHTML = html

_.replaceInnerHTML = (node, html) ->
    node.innerHTML = html

_.replaceHTML = (node, html) ->
    node.outerHTML = html

_.attachHTML = (node, html) ->
    node.insertAdjacentHTML 'beforeend', html

_.createTag = (tag) -> (...args) ->

    result = ['<', tag]

    if args[0] and typeof args[0] is not 'string'
        obj = args.shift!
        for own key, val of obj
            result.push " #{key}=\"#{val}\""

    result.push '>'
    result .= concat args
    result.push "</#{tag}>"

    return result.join ''

####

_.parseNode = (html) ->
    document.createRange!createContextualFragment html

#########################################

vaultStore = (key, value) -> localStorage.setItem(key, JSON.stringify(value))
vaultRetrieve = (key) -> JSON.parse(localStorage.getItem(key))
vaultRemove = (key) -> localStorage.removeItem(key)
vaultClear = -> localStorage.clear!

_.vault = (key, value) ->

    if arguments.length is 0
        return localStorage

    if arguments.length is 1
        return vaultRetrieve key

    if arguments.length is 2
        return vaultStore key, value

_.vault.store = vaultStore
_.vault.retrieve = vaultRetrieve
_.vault.set = vaultStore
_.vault.get = vaultRetrieve
_.vault.remove = vaultRemove
_.vault.remove = vaultRemove
_.vault.clear = vaultClear
_.vault.empty = vaultClear

#########################################

# 5 |> times -> ....
_.times = (f) -> (n) ->
    i = 0
    while i++ < n
        f i

# repeat 5 -> ....
_.repeat = (n, f) ->
    i = 0
    while i++ < n
        f i

#########################################

_.TCO = Symbol 'TCO'

_.goto = -> [TCO, ...arguments]

_.tco = (res) ->
    for ever
        if (Array.isArray res)
        and (res[0] is TCO)
            res.shift!
            res = res.shift! ...res
        else return res
do ->

    count = (n) ->
        if n > 1000000
            return n
        goto count, ++n

    count2 = (n) ->
        if n > 1000000
            return n
        return count2 ++n

    _.libraTest.countWithTCO = -> tco count 0

    _.libraTest.countWithoutTCO = -> count2 0

#########################################

do ->

    _.css = (arg) ->

    _.css.preprocessors = {test: -> ['line 1 a', 'line 1 b']}
    _.css.stylesheets = {}
    _.css.bindings = {}

    _.css.remove = (name) ->
        _.css.stylesheets[name].remove()

    _.css.get = (name) ->
        _.css.stylesheets[name].innerHTML

    _.css.log = (name) ->
        log _.css.stylesheets[name].innerHTML
        _.css.stylesheets[name].innerHTML

    _.css.disable = (name) ->
        _.css.stylesheets[name].disabled = true

    _.css.enable = (name) ->
        _.css.stylesheets[name].disabled = false

    _.css.append = (name, code) ->
        changeCSS name, code, false

    _.css.replace = (name, code) ->
        changeCSS name, code, false

    bufferBindings = (bindings) ->
        for key, val of bindings
            _.css.bindings[key] = val


    flushBindings = ->

        cssLines = [
            '/* bindings.libra.css */'
            ''
            ':root {'
        ]

        for key, val of _.css.bindings
            cssLines.push "    --#{key}: #{val};"
        cssLines.push '}'
        cssCode = cssLines.join '\n'

        unless _.css.stylesheets.bindings?
            node = document.createElement 'style'
            node = ($ 'head').appendChild node
            _.css.stylesheets.bindings = node

        _.css.stylesheets.bindings.innerHTML = cssCode 

    _.css.bind = (bindings) ->
        bufferBindings bindings
        flushBindings!

    _.changeCSS = (name, code, replaceMode) ->
        # used by css.append and css.replace

        css = """
        /* #{name}.libra.css */

        #{_.css.parse code}\n
        """

        log css

        unless _.css.stylesheets.name?
            node = document.createElement 'style'
            node = ($ 'head').appendChild node
            _.css.stylesheets[name] = node

        stylesheet = _.css.stylesheets[name]

        if replaceMode
        then stylesheet.innerHTML += css
        else stylesheet.innerHTML = css

        return stylesheet

    _.css.parse = (string) ->
        # translates libra-css into standard css

        splitmark = ' SPLITMARK '
        string .= replaceAll /\r?\n[ \t]+/g, splitmark
        log string

        lines = getLines string
        lines .= map -> it.trim!
        lines .= map preprocess
        lines .= flat!
        lines .= map translate
        lines .= filter -> it is not ''

        code = lines.join '\n'
        code .= replaceAll ' (', ' calc(' # replace with something more robust.
        code .= replaceAll /\$([a-zA-Z0-9-_]+)/g, 'var(--$1)'

        chunks = code.split 'SELECT '
        chunks .= map -> it.trim!
        chunks .= filter -> it is not ''

        chunks .= map (chunk) ->
            lines = chunk.split '\n'
            lines[0] += ' {'
            lines .= map -> "    #it"
            lines[0] .= trim!
            lines.push '}'
            lines.join '\n'

        flushBindings!

        return chunks.join('\n\n').replaceAll(/[ ]+SPLITMARK[ ]?/g, '\n    ')

    preprocess = (line) ->
        # helper for css.parse

        # get first word of line

        index = line.indexOf ' '
        if index is -1 then index = line.length

        # if first line has preprocessor registered, use it.
        # otherwise, return line unchanged.

        preprocFunc = css.preprocessors[line.substring 0, index] 

        if isFunction preprocFunc
        then return preprocFunc line
        else return [line]

    translate = (line) ->
        # helper for css.parse

        return line if line is ''
        return line if line.startsWith 'SELECT '

        if line.startsWith '#'
            line .= replace '#', ''
            line .= trim!
            return "/* #{line} */"

        if '=' in line
            parts = line.split '='
            parts .= map -> it.trim!
            return "--#{parts[0]}: #{parts[1]};"

        index = line.indexOf ' '
        if index is -1
            return line + ':;'
        head = line.substring 0, index
        tail = line.substring index
        return "#{head}:#{tail};"


    _.css.preprocessors.bg = -> it.replace 'bg', 'background-color'

    _.css.preprocessors.let = (line) ->
        regex = /^let[ ]+([a-zA-Z0-9-_]+)[ ]+=[ ]+(\S.*)$/
        result = regex.exec line
        if isNull result then throw "error: libra-css just can't with this line: #line"
        bufferBindings "#{result[1]}": result[2]
        return ''

## DOCUMENTATION ###############################################################

/*

place documentation here.

*/

