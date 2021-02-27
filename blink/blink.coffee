################################################################################

window.onload = ->

    pwHashStored = await secret.digest vault.get 'pw'

    if pwHashStored is pwHash
        runBlink()
    else
        runLockScreen()

pwHash = "66ad717549fa79c845a74802f4df36781e2e0eab29fb0aa420b04dfb39944fd6"

runLockScreen = ->

    lockScreen = -> 
        '<input class="lockScreen" type="password" placeholder="enter password"></input>'

    changeHandler = ->
        hash = await secret.digest $('input').value
        if hash is pwHash
            vault.set 'pw', $('input').value
            runBlink()
        else
            $('input').value = ''
            $('input').placeholder = 'try again'
            shake $('input')
            log 'yay'

    shake = (node) ->
        node = $ node if isString node

        node.classList.remove 'snake'
        log node.offsetWidth
        node.classList.add 'snake'

    replaceInnerHTML 'body', lockScreen()
    ($ 'input').addEventListener('change', changeHandler)

    css '''

    SELECT body
        fullscreen
        display grid
        bg #130d0d

    SELECT .lockScreen
        border none
        display block
        padding 20px
        place-self center
        bg rgb(40 40 40)
        border-radius 12px
        color black
        font 18px bold sans-serif

    SELECT *:focus
        outline none

    SELECT .snake
        animation shake-horizontal 250ms

    '''

################################################################################

do ->

    #$('title').text = 'test'

    css.preprocessors.fullscreen = -> '''
    height 100vh
    width 100vw
    margin 0
    '''

    css.preprocessors.textClip = (line) -> """
    background #{line.split(' ')[1]}
    background-clip text
    color transparent
    """

################################################################################

light = null

{ div, input, span } = html.elements()

################################################################################

audio = off
randomizer = off
mode = 'morse'

audioCtx = new AudioContext()
window.osc = audioCtx.createOscillator()
osc.frequency.value = 440
osc.start()

window.knockLetters = {}

do ->

    for char, idx in ' abcdefghijklmnopqrstuvwxyz' 

        digits = (zFill idx.toString(3), 3)
        .split ''
        .map (digits) ->
            (parseInt(digit, 3) + 1 for digit in digits)
        .join ''

        #log char, digits

        knockLetters[char] = digits

morseChars = '''
    A .-
    B -...
    C -.-.
    D -..
    E .
    F ..-.
    G --.
    H ....
    I ..
    J .---
    K -.-
    L .-..
    M --
    N -.
    O ---
    P .--.
    Q --.-
    R .-.
    S ...
    T -
    U ..-
    V ...-
    W .--
    X -..-
    Y -.--
    Z --..
    1 .----
    2 ..---
    3 ...--
    4 ....-
    5 ......
    6 -....
    7 --...
    8 ---..
    9 ----.
    0 -----
'''

scope ->

    res = {}

    for pair in morseChars.trim().split('\n')
        [a, b] = pair.split ' '
        res[a] = b

    morseChars = res

    global { morseChars }

################################################################################

blinkOn = ->
    light.classList.add 'on'
    osc.connect(audioCtx.destination) if (audio is on)

blinkOff = ->
    light.classList.remove 'on'
    osc.disconnect()

blink = (duration) ->
    if randomizer is on
        osc.frequency.value = random 100, 1000
        css light: "rgb(#{random 0, 255} #{random 0, 255} #{random 0, 255})"
    blinkOn()
    await sleep duration
    blinkOff()

#osc.frequency.value = random 100, 1000

################################################################################

scope ->

    dot = 100
    dash = dot * 3
    short = dot
    medium = dot * 3
    long = dot * 7

    translateText = (text) -> text.split(' ').map(translateWord).join('l')

    translateWord = (word) -> word.split('').map(translateChar).join('m')

    translateChar = (char) -> morseChars[char.toUpperCase()].split('').join('s')

    morse = (text) ->
        symbols = translateText text
        for symbol in symbols
            switch symbol
                when '.' then await blink dot
                when '-' then await blink dash
                when 's' then await sleep short
                when 'm' then await sleep medium
                when 'l' then await sleep long

    global { morse, translateText, translateWord, translateChar }

################################################################################

scope ->

    knockLength = 100
    shortPause = 100
    mediumPause = 300
    longPause = 700

    knock = (text) ->

        for char in text
            await knockChar char
            await sleep longPause

    knockChar = (char) ->
        digits = knockLetters[char.toLowerCase()].split ''
        return digits unless digits
        await knockDigit digits[0]
        await sleep mediumPause
        await knockDigit digits[1]
        await sleep mediumPause
        await knockDigit digits[2]
        return 'done'

    knockDigit = (digit) ->
        await blink knockLength
        if parseInt(digit) > 1
            await sleep shortPause
            await blink knockLength
        if parseInt(digit) > 2
            await sleep shortPause
            await blink knockLength

    global { knock, knockChar, knockDigit }

################################################################################

blinkputHandler = ->

    text = ($ 'input').value

    audio = on if text is 'soundOn'
    audio = off if text is 'soundOff'
    randomizer = on if text is 'randomOn'
    randomizer = off if text is 'randomOff'

    mode = 'knock' if text is 'knockMode'
    mode = 'morse' if text is 'morseMode'

    if text not in ['soundOn', 'soundOff', 'randomOn', 'randomOff', 'knockMode', 'morseMode']
        knock text if mode is 'knock'
        morse text if mode is 'morse'

    ($ 'input').value = ''

runBlink = ->

    log ['soundOn', 'soundOff', 'randomOn', 'randomOff', 'knockMode', 'morseMode']

    replaceInnerHTML 'body',
        div {id: 'box'},
            div {id: 'blink'}
            div {id: 'line'},
                div {id: 'rndBtn', class: 'btnOff'}, 'RND'
                input {id: 'blinkput'}
                div {id: 'sndBtn', class: 'btnOff'}, 'SND'

    light = $ '#blink'

    ($ 'input').addEventListener('change', blinkputHandler)
    #($ '#rndBtn').addEventListener('click', rndClickHandler)
    #($ '#rndBtn').addEventListener('click', rndClickHandler)

    css.bind
        light: 'rgb(255, 70, 70)'
        input: 'rgb(40, 40, 40)'
        btnOn: 'rgb(63, 106, 51)'
        btnOff: 'rgb(67, 67, 72)'
        border: 'ivory'

    css '''

    SELECT body
        fullscreen
        display grid
        bg #130d0d

    SELECT #blink
        place-self center
        height 150px
        width 150px
        bg rgb(10 10 10)
        border-radius 100%
        margin-bottom 60px

    SELECT #blink.on
        bg $light

    SELECT #box
        place-self center
        display grid

    SELECT #blinkput
        border none
        bg $input
        color black
        #margin 0px 10px
        #border-left 2px solid $border
        #border-right 2px solid $border
        padding 0px 10px
        font bold 14px sans-serif

    SELECT #line
        height 30px
        width 400px
        display grid
        #grid-template-columns 50px 1fr 50px
        grid-template-columns 1fr
        #border 2px solid $border

    SELECT #rndBtn, #sndBtn
        color black
        display none
        place-content center
        align-items center
        font bold 14px sans-serif

    SELECT .btnOn
        bg $btnOn

    SELECT .btnOff
        bg $btnOff

    SELECT *:focus
        outline none

    '''

global { blinkOn, blinkOff, blink }

