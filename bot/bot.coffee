window.onload = -> lock 'bot', bot

bot = ->

    { div, input } = html.elements()

    # 2147483583 seems to be the max scroll height, at least in FF
    scrollPosition = 2147483583

    window.setScrollPosition = (n) -> scrollPosition = n

    log 'setScrollPosition'
    log 'https://dog.ceo/api/breeds/list/all'

    attachHTML 'body', div {id: 'botContainer'}, div {id: 'botLines'}
    attachHTML 'body', input {id: 'userInput'}
    #attachHTML 'body', div {id: 'leftContainer'}
    #attachHTML 'body', div {id: 'rightContainer'}

    i = 0

    bc = $ '#botContainer'
    userInput = $ '#userInput'

    $('#userInput').onkeyup = (e) ->
        #log(e.key)
        if e.key is 'Enter'
            command = userInput.value
            userInput.value = ''
            switch command
                when 'test' then addLine()
                when 'fox' then addCreature 'https://randomfox.ca/floof/', 'image'
                when 'cat' then addCreature 'https://aws.random.cat/meow', 'file'

            if command.startsWith 'dog'
                parts = command.split ' '
                return if parts[0] isnt 'dog'
                if parts.length is 1
                    addCreature 'https://dog.ceo/api/breeds/image/random', 'message'
                if parts.length is 2
                    addCreature "https://dog.ceo/api/breed/#{parts[1]}/images/random", 'message'
                if parts.length is 3
                    addCreature "https://dog.ceo/api/breed/#{parts[1]}/#{parts[2]}/images/random", 'message'

    window.addLine = ->
        attachHTML '#botLines', div {class: 'botLine'}, "test #{i++}"

        # 2147483583 seems to be the max scroll height, at least in FF
        log scrollPosition
        bc.scroll 0, scrollPosition

    window.addCreature = (url, path) ->

        line = document.createElement('div')
        line.classList.add('botLine')
        line.innerText = 'image loading'
        ($ '#botLines').appendChild line

        fox = (await fetchJSON url)[path]

        img = document.createElement('img')
        img.src = fox
        img.classList.add('botLineImg')
        img.onload = ->
            line.childNodes[0].remove()
            line.appendChild img
            bc.scroll 0, scrollPosition

        # 2147483583 seems to be the max scroll height, at least in FF
        bc.scroll 0, scrollPosition

    css '''

    select body
        fullscreen
        bg #1d1d1d
        display grid
        grid-template-columns 400px 1fr 400px
        grid-template-rows 1fr 50px

    select #botContainer
        grid-area 1 / 2
        overflow-y scroll
        scrollbar-width none
        #border 2px solid black
        #border-bottom none

    select #botLines
        display flex
        flex-direction column
        justify-content end
        min-height 100%

    select #userInput
        grid-area 2 / 2
        bg #1d1d1d
        font-size 18px
        font-family mono
        #font-weight bold
        padding 0px 10px
        border none
        border-top 2px solid black

    select .botLine
        padding 20px
        font-size 30px
        display grid
        place-content center
        border-top 2px solid black

    select .botLineImg
        max-height 600px

    select *:focus
        outline none

    '''

# list dog breeds
# https://dog.ceo/api/breeds/list/all

# random dog
# https://dog.ceo/api/breeds/image/random

# random dog by breed (.message)
# https://dog.ceo/api/breed/xxxx/images/random

# random dog by sub breed
# https://dog.ceo/api/breed/xxxx/yyyy/images/random

# random fox
# https://randomfox.ca/floof/

# random cat
# https://aws.random.cat/meow

# random dog
# https://random.dog/woof.json

