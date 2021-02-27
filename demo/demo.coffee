################################################################################

pwHash = "66ad717549fa79c845a74802f4df36781e2e0eab29fb0aa420b04dfb39944fd6"
loggedIn = false
i = 0

window.onload = ->

    pwHashStored = await secret.digest vault.get 'pw'

    if pwHashStored is pwHash
        loggedIn = true
        showState state[i]
    else
        runLockScreen()

runLockScreen = ->

    lockScreen = -> 
        '<input class="lockScreen" type="password" placeholder="enter password"></input>'

    changeHandler = ->
        hash = await secret.digest $('input').value
        if hash is pwHash
            vault.set 'pw', $('input').value
            loggedIn = true
            showState state[i]
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
        #bg #130d0d

    SELECT input
        border none
        display block
        padding 20px
        place-self center
        background-color #1e1818
        border-radius 12px
        color #f22
        font-size 18px

    SELECT *:focus
        outline none

    SELECT .snake
        animation shake-horizontal 250ms

    '''

################################################################################

window.onkeyup = (event) ->

    if loggedIn
        if event.code in ['KeyA', 'ArrowLeft']
            replaceInnerHTML ($ 'body'), state data[--i %% 50]
        if event.code in ['KeyD', 'ArrowRight']
            replaceInnerHTML ($ 'body'), state data[++i %% 50]

div = createTag 'div'

entry = (key, value) ->
    div class: 'entry',
        div class: 'key', key
        div class: 'value', value

showState = (stateData) ->
    replaceHTML 'body', state data[i % 50]

state = (stateData) ->
        div class: 'box',
            div class: 'category', 'US States'
            entry "State", link stateData[0], stateData[1].replaceAll('_', ' ')
            entry "Abbreviation", stateData[2]
            entry "Statehood since", stateData[3]
            entry "Capital", link stateData[4], stateData[5].replaceAll('_', ' ')
            entry "Capital since", stateData[6]
            entry "Area (mi²", stateData[7].split('.')[0]
            entry "Area (mi²)", stateData[8].split('.')[0]
            entry "City Population", stateData[9]
            entry "Metro Population", stateData[10]

link = (target, text) ->
    """<a href="#target">#{text}</a>"""

css '''

    SELECT :root
        $boxA #a84848
        $boxB #665132
        $boxC #826c4e
        $lineA #d0d0d0
        $textA #d0d0d0

    SELECT body
        margin 0px
        height 100vh
        width 100vw
        display grid

        bg url("canyon.jpg") top right / cover, black

        #background-image: url("canyon.jpg");
        #background-position: top right;
        #background-size: cover;

    SELECT .box
        place-self center
        height 500px
        width 500px
        bg ivory
        border-radius 40px
        display grid
        grid-template-rows repeat(10, 1fr)
        overflow hidden
        border 2px solid $lineA

    SELECT .entry
        display grid
        grid-template-columns 1fr 1fr
        border-top 2px solid $lineA

    SELECT .category, .key, .value
        display flex
        align-items center
        place-content center
        font small-caps bold 20px sans-serif
        color $textA

    SELECT a
        color $textA
        text-decoration none

    SELECT .category
        bg $boxA

    SELECT .key
        bg $boxB
        border-right 2px solid $lineA

    SELECT .value
        bg $boxC

'''

data = shuffle [["https://simple.wikipedia.org/wiki/Alabama","Alabama","AL","1819","https://simple.wikipedia.org/wiki/Montgomery,_Alabama","Montgomery","1846","159.8","413.8801","198,218","373,903"],["https://simple.wikipedia.org/wiki/Alaska","Alaska","AK","1959","https://simple.wikipedia.org/wiki/Juneau,_Alaska","Juneau","1906","2716.7","7036.220699","31,275"],["https://simple.wikipedia.org/wiki/Arizona","Arizona","AZ","1912","https://simple.wikipedia.org/wiki/Phoenix,_Arizona","Phoenix","1889","517.6","1340.577846","1,660,272","4,857,962"],["https://simple.wikipedia.org/wiki/Arkansas","Arkansas","AR","1836","https://simple.wikipedia.org/wiki/Little_Rock,_Arkansas","Little_Rock","1821","116.2","300.9566184","193,524","699,757"],["https://simple.wikipedia.org/wiki/California","California","CA","1850","https://simple.wikipedia.org/wiki/Sacramento,_California","Sacramento","1854","97.9","253.559836","508,529","2,345,210"],["https://simple.wikipedia.org/wiki/Colorado","Colorado","CO","1876","https://simple.wikipedia.org/wiki/Denver,_Colorado","Denver","1867","153.3","397.0451773","716,492","2,932,415"],["https://simple.wikipedia.org/wiki/Connecticut","Connecticut","CT","1788","https://simple.wikipedia.org/wiki/Hartford,_Connecticut","Hartford","1875","17.3","44.80679431","124,775","1,212,381"],["https://simple.wikipedia.org/wiki/Delaware","Delaware","DE","1787","https://simple.wikipedia.org/wiki/Dover,_Delaware","Dover","1777","22.4","58.01573367","36,047","162,310"],["https://simple.wikipedia.org/wiki/Florida","Florida","FL","1845","https://simple.wikipedia.org/wiki/Tallahassee,_Florida","Tallahassee","1824","95.7","247.8618622","181,376","367,413"],["https://simple.wikipedia.org/wiki/Georgia_(U.S._state)","Georgia","GA","1788","https://simple.wikipedia.org/wiki/Atlanta","Atlanta","1868","133.5","345.7634127","498,044","5,949,951"],["https://simple.wikipedia.org/wiki/Hawaii","Hawaii","HI","1959","https://simple.wikipedia.org/wiki/Honolulu","Honolulu","1845","68.4","177.1551867","359,870","953,207"],["https://simple.wikipedia.org/wiki/Idaho","Idaho","ID","1890","https://simple.wikipedia.org/wiki/Boise,_Idaho","Boise","1865","63.8","165.2412414","205,671","616,561"],["https://simple.wikipedia.org/wiki/Illinois","Illinois","IL","1818","https://simple.wikipedia.org/wiki/Springfield,_Illinois","Springfield","1837","54","139.859358","116,250","210,170"],["https://simple.wikipedia.org/wiki/Indiana","Indiana","IN","1816","https://simple.wikipedia.org/wiki/Indianapolis","Indianapolis","1825","361.5","936.2807019","867,125","2,004,230"],["https://simple.wikipedia.org/wiki/Iowa","Iowa","IA","1846","https://simple.wikipedia.org/wiki/Des_Moines,_Iowa","Des_Moines","1857","75.8","196.3210988","203,433","569,633"],["https://simple.wikipedia.org/wiki/Kansas","Kansas","KS","1861","https://simple.wikipedia.org/wiki/Topeka,_Kansas","Topeka","1856","56","145.0393342","127,473","230,870"],["https://simple.wikipedia.org/wiki/Kentucky","Kentucky","KY","1792","https://simple.wikipedia.org/wiki/Frankfort,_Kentucky","Frankfort","1792","14.7","38.07282522","25,527","70,758"],["https://simple.wikipedia.org/wiki/Louisiana","Louisiana","LA","1812","https://simple.wikipedia.org/wiki/Baton_Rouge,_Louisiana","Baton_Rouge","1880","76.8","198.9110869","225,374","830,480"],["https://simple.wikipedia.org/wiki/Maine","Maine","ME","1820","https://simple.wikipedia.org/wiki/Augusta,_Maine","Augusta","1832","55.4","143.4853413","19,136","117,114"],["https://simple.wikipedia.org/wiki/Maryland","Maryland","MD","1788","https://simple.wikipedia.org/wiki/Annapolis,_Maryland","Annapolis","1694","6.73","17.43061998","38,394"],["https://simple.wikipedia.org/wiki/Massachusetts","Massachusetts","MA","1788","https://simple.wikipedia.org/wiki/Boston","Boston","1630","89.6","232.0629347","694,583","4,628,910"],["https://simple.wikipedia.org/wiki/Michigan","Michigan","MI","1837","https://simple.wikipedia.org/wiki/Lansing,_Michigan","Lansing","1847","35","90.64958386","114,297","464,036"],["https://simple.wikipedia.org/wiki/Minnesota","Minnesota","MN","1858","https://simple.wikipedia.org/wiki/Saint_Paul,_Minnesota","Saint_Paul","1849","52.8","136.7513722","285,068","3,348,659"],["https://simple.wikipedia.org/wiki/Mississippi","Mississippi","MS","1817","https://simple.wikipedia.org/wiki/Jackson,_Mississippi","Jackson","1821","104.9","271.6897528","173,514","567,122"],["https://simple.wikipedia.org/wiki/Missouri","Missouri","MO","1821","https://simple.wikipedia.org/wiki/Jefferson_City,_Missouri","Jefferson_City","1826","27.3","70.70667541","43,079","149,807"],["https://simple.wikipedia.org/wiki/Montana","Montana","MT","1889","https://simple.wikipedia.org/wiki/Helena,_Montana","Helena","1875","14","36.25983354","28,190","74,801"],["https://simple.wikipedia.org/wiki/Nebraska","Nebraska","NE","1867","https://simple.wikipedia.org/wiki/Lincoln,_Nebraska","Lincoln","1867","74.6","193.213113","258,379","302,157"],["https://simple.wikipedia.org/wiki/Nevada","Nevada","NV","1864","https://simple.wikipedia.org/wiki/Carson_City,_Nevada","Carson_City","1861","143.4","371.404295","55,274"],["https://simple.wikipedia.org/wiki/New_Hampshire","New_Hampshire","NH","1788","https://simple.wikipedia.org/wiki/Concord,_New_Hampshire","Concord","1808","64.3","166.5362355","42,695","146,445"],["https://simple.wikipedia.org/wiki/New_Jersey","New_Jersey","NJ","1787","https://simple.wikipedia.org/wiki/Trenton,_New_Jersey","Trenton","1784","7.66","19.83930893","84,913","366,513"],["https://simple.wikipedia.org/wiki/New_Mexico","New_Mexico","NM","1912","https://simple.wikipedia.org/wiki/Santa_Fe,_New_Mexico","Santa_Fe","1610","37.3","96.60655652","75,764","183,732"],["https://simple.wikipedia.org/wiki/New_York_(state)","New_York","NY","1788","https://simple.wikipedia.org/wiki/Albany,_New_York","Albany","1797","21.4","55.42574556","97,856","857,592"],["https://simple.wikipedia.org/wiki/North_Carolina","North_Carolina","NC","1789","https://simple.wikipedia.org/wiki/Raleigh,_North_Carolina","Raleigh","1792","114.6","296.8126374","403,892","1,130,490"],["https://simple.wikipedia.org/wiki/North_Dakota","North_Dakota","ND","1889","https://simple.wikipedia.org/wiki/Bismarck,_North_Dakota","Bismarck","1883","26.9","69.67068017","61,272","108,779"],["https://simple.wikipedia.org/wiki/Ohio","Ohio","OH","1803","https://simple.wikipedia.org/wiki/Columbus,_Ohio","Columbus","1816","210.3","544.6744996","892,553","2,078,725"],["https://simple.wikipedia.org/wiki/Oklahoma","Oklahoma","OK","1907","https://simple.wikipedia.org/wiki/Oklahoma_City","Oklahoma_City","1910","620.3","1606.569625","649,021","1,396,445"],["https://simple.wikipedia.org/wiki/Oregon","Oregon","OR","1859","https://simple.wikipedia.org/wiki/Salem,_Oregon","Salem","1855","45.7","118.3624566","154,637","390,738"],["https://simple.wikipedia.org/wiki/Pennsylvania","Pennsylvania","PA","1787","https://simple.wikipedia.org/wiki/Harrisburg,_Pennsylvania","Harrisburg","1812","8.11","21.00480357","49,528","647,390"],["https://simple.wikipedia.org/wiki/Rhode_Island","Rhode_Island","RI","1790","https://simple.wikipedia.org/wiki/Providence,_Rhode_Island","Providence","1900","18.5","47.91478004","178,042","1,600,852"],["https://simple.wikipedia.org/wiki/South_Carolina","South_Carolina","SC","1788","https://simple.wikipedia.org/wiki/Columbia,_South_Carolina","Columbia","1786","125.2","324.2665114","129,272","767,598"],["https://simple.wikipedia.org/wiki/South_Dakota","South_Dakota","SD","1889","https://simple.wikipedia.org/wiki/Pierre,_South_Dakota","Pierre","1889","13","33.66984543","13,646"],["https://simple.wikipedia.org/wiki/Tennessee","Tennessee","TN","1796","https://simple.wikipedia.org/wiki/Nashville,_Tennessee","Nashville","1826","525.9","1362.074747","691,243","1,903,045"],["https://simple.wikipedia.org/wiki/Texas","Texas","TX","1845","https://simple.wikipedia.org/wiki/Austin,_Texas","Austin","1839","305.1","790.2053725","964,254","2,168,316"],["https://simple.wikipedia.org/wiki/Utah","Utah","UT","1896","https://simple.wikipedia.org/wiki/Salt_Lake_City","Salt_Lake_City","1858","109.1","282.5677028","186,440","1,087,873"],["https://simple.wikipedia.org/wiki/Vermont","Vermont","VT","1791","https://simple.wikipedia.org/wiki/Montpelier,_Vermont","Montpelier","1805","10.2","26.41787873","7,855"],["https://simple.wikipedia.org/wiki/Virginia","Virginia","VA","1788","https://simple.wikipedia.org/wiki/Richmond,_Virginia","Richmond","1780","60.1","155.6582854","204,214","1,208,101"],["https://simple.wikipedia.org/wiki/Washington_(state)","Washington","WA","1889","https://simple.wikipedia.org/wiki/Olympia,_Washington","Olympia","1853","16.7","43.25280144","46,478","234,670"],["https://simple.wikipedia.org/wiki/West_Virginia","West_Virginia","WV","1863","https://simple.wikipedia.org/wiki/Charleston,_West_Virginia","Charleston","1885","31.6","81.84362429","51,400","304,214"],["https://simple.wikipedia.org/wiki/Wisconsin","Wisconsin","WI","1848","https://simple.wikipedia.org/wiki/Madison,_Wisconsin","Madison","1838","68.7","177.9321832","233,209","605,435"],["https://simple.wikipedia.org/wiki/Wyoming","Wyoming","WY","1890","https://simple.wikipedia.org/wiki/Cheyenne,_Wyoming","Cheyenne","1869","21.1","54.64874913","59,466","91,738"]]

