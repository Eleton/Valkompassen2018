import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { content : List (Html Msg)
  , result : List Ideology
  , cookieDisplay : Bool
  , sd : Bool
  }

model : Model
model = Model content [] True False


content : List (Html Msg)
content =
  [ frontBox
  , questionBox question1
  , questionBox question2
  , questionBox question3
  , questionBox question4
  ]

type alias Question =
  { question : String
  , firstAnswer : Answer
  , secondAnswer : Answer
  }

type alias Answer =
  { ideology : Ideology
  , text : String
  }

type Ideology 
  = Left
  | Right

question1 : Question
question1 =
  Question
    "Vad är det finaste som en stat kan ge dig?"
    (Answer Left "Trygghet")
    (Answer Right "Frihet")

question2 : Question
question2 =
  Question
    "Vilket av följande personlighetsdrag anser du är osexigast hos en partner?"
    (Answer Left "Girighet")
    (Answer Right "Lathet")

question3 : Question
question3 =
  Question
    "Vem var din favoritseriefigur som barn?"
    (Answer Left "Bamse")
    (Answer Right "Joakim von Anka")

question4 : Question
question4 =
  Question
    "Vilken är den största skandalen i modern tid?"
    (Answer Left "Lantisar")
    (Answer Right "Toblerone")

blue : String
--blue = "rgb(0, 106, 179)"
--blue = "rgb(87, 192, 232)"
--blue = "hsl(197, 75%, 60%)"
blue = "hsl(191, 100%, 45%)"

red : String
--red = "rgb(237, 27, 52)"
--red = "rgb(234, 91, 104)"
red = "hsl(0, 75%, 60%)"

green : String
--green = "rgb(76, 175, 80)"
green = "hsl(115, 50%, 65%)"
--green = "hsl(119, 20%, 60%)"
--green = "#e48552"

yellow : String
yellow = "hsl(50, 100%, 50%)"


-- UPDATE

type Msg
  = Reset
  | AddAnswer Ideology
  | Start
  | Redo
  | SD


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> model
    AddAnswer ideology ->
      { model
      | result = ideology :: model.result
      , content = Maybe.withDefault [] (List.tail model.content)
      }
    Start ->
      { model | content = Maybe.withDefault [] (List.tail model.content), cookieDisplay = False }
    Redo -> Model content [] False False
    SD -> { model | sd = True }


-- VIEW

view : Model -> Html Msg
view model =
  div [ container ]
  [ if model.sd == False then resultBox model.result else sdBox
  , Maybe.withDefault (div [] []) (List.head model.content)
  ]

frontBox : Html Msg
frontBox =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass" ]
  , Html.p [ paragraphStyle ] [ text "Gör Aimans Valkompass™ och ta reda på vilket parti du borde rösta på i valet 2018!" ]
  , div [ paragraphStyle, style [("font-size", "3vh")] ]
    [ Html.p [ style [("margin", "0")] ] [ text "Observera att denna sida inte använder kakor."]
    , Html.p [ style [("margin", "0")] ] [ text "Ingenting kommer hända om du trycker på följande knapp:"]
    , button [ buttonStyle "ivory", style [("color", "#222"), ("border", "1px solid #222")] ] [ text "Jag förstår." ]
    ]
  , div [ boxContainer ]
    [ button [ onClick Start, buttonStyle green ] [ text "Start" ]
    ]
  ]

resultBox : List Ideology -> Html Msg
resultBox result =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass" ]
  , div [ boxContainer ] [(resultToBar result)]
  , Html.p [ paragraphStyle ] [ text (resultToText result) ]
  , div [ boxContainer ]
    [ button [ onClick SD, buttonStyle yellow, style [("color", "#222")] ] [ text "Jag är missnöjd." ]
    ]
  , div [ boxContainer ]
    [ button [ onClick Redo, buttonStyle green ] [ text "Gör om" ]
    ]
  ]

sdBox : Html Msg
sdBox =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass" ]
  , div [ boxContainer ] [ Html.img [ src "jimmie.jpg", jimmieImg ] [] ]
  --, div [ boxContainer ] [(resultToBar result)]
  , Html.p [ paragraphStyle ] [ text "Jimmie Åkesson, tjala lala laaa~" ]
  , div [ boxContainer ]
    [ button [ onClick Redo, buttonStyle yellow ] [ text "Gör om" ]
    ]
  ]

questionBox : Question -> Html Msg
questionBox q =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass" ]
  , Html.p [ paragraphStyle ] [ text q.question ]
  , div [] [
    button
      [ onClick (AddAnswer q.firstAnswer.ideology), buttonStyle red ]
      [ text q.firstAnswer.text]
    , button
      [ onClick (AddAnswer q.secondAnswer.ideology), buttonStyle blue ]
      [ text q.secondAnswer.text ]
    ]
  ]


-- HELP FUNCTIONS

resultToText : List Ideology -> String
resultToText list =
  case (sortIdeology list) of
    [ Left, Left, Left, Left ] ->
      "Du är helt klart vänster, kamrat! Aimans Valkompass föreslår därför att du röstar på ett parti på den vänstra halvan av spektrumet, till exempel V, MP eller möjligtvis S."
    [ Left, Left, Left, Right ] ->
      "Du är mestadels röd, men besitter ändå en respekt för marknadens läkande krafter. S och MP ligger nära till hands. Man kan rösta V också, men det kanske man inte ska skylta med om man umgås i dina kretsar."
    [ Left, Left, Right, Right ] ->
      "Det är omöjligt att placera dig helt klockrent på Höger/Vänster-skalan. Du svajar helt enkelt för mycket i din ideologi. Statistiskt sett så borde du rösta på S, men Reinfeldt-M går också bra."
    [ Left, Right, Right, Right ] ->
      "Du är lika blå som röda havet. C, M och Birgitta Ohlsson-fallangen av L skulle kunna vara ett nyktert val för din del."
    [ Right, Right, Right, Right ] ->
      "Du är uppenbart genomblå! Du kan välja fritt inom Alliansen, men kom ihåg - En stödröst på KD kan rädda Allianssamarbetet."
    _ ->
      "Data saknas för att kunna avgöra din politiska hållning."

resultToBar : List Ideology -> Html Msg
resultToBar list =
  div [ style [ ("margin-top", "2vh") ] ]
  [ div [ style [ ("font-size", "3vh"), ("font-family", "arial,sans-serif") ] ] [ text ("Resultat: " ++ (resultToPercentage list)) ]
  , div [ ideologyBar ] (List.map
      (\x -> if x == Left
        then div [ style [ ("background-color", red) , ("height", "100%"), ("flex", "1") ] ] []
        else div [ style [ ("background-color", blue), ("height", "100%"), ("flex", "1") ] ] []
        ) (sortIdeology list)
      )
  ]

sortIdeology : List Ideology -> List Ideology
sortIdeology list =
  case list of
    [] -> []
    Left :: tail ->
      Left :: sortIdeology tail
    Right :: tail ->
      (sortIdeology tail) ++ [Right]

resultToPercentage : List Ideology -> String
resultToPercentage list =
  let
    percentageUnits = 100 // (List.length list)
    amountOfRed = List.length (List.filter (\x -> x == Left) list)
    amountOfBlue = List.length (List.filter (\x -> x == Right) list)
  in
    (toString (amountOfRed*percentageUnits)) ++ "% röd/" ++ (toString (amountOfBlue*percentageUnits)) ++ "% blå"

-- STYLE

container = 
  style
    [ ("background-color", green)
    , ("height", "100vh")
    , ("display", "flex")
    , ("flex-direction", "column")
    , ("justify-content", "center")
    ]

boxContainer =
  style
    [ ("display", "flex")
    , ("justify-content", "center")
    ]

box =
  style
    [ ("width", "80vw")
    , ("max-width", "800px")
    , ("height", "80vh")
    , ("padding", "20px")
    , ("padding-top", "4vh")
    , ("padding-bottom", "3vh")
    , ("background-color", "ivory")
    --, ("border", "2px solid #222")
    --, ("box-shadow", "0 0 50px #222")
    , ("border-radius", "40px")
    , ("text-align", "center")
    , ("position", "absolute")
    , ("top", "50%")
    , ("left", "50%")
    , ("transform", "translate(-50%, -50%)")
    , ("display", "flex")
    , ("flex-direction", "column")
    , ("justify-content", "space-between")
    , ("color", "#222")
    ]

buttonStyle color =
  style
    [ ("font-size", "4vh")
    , ("border", "none")
    , ("background-color", color)
    , ("border-radius", "80px")
    , ("margin", "15px")
    , ("padding", "10px 20px")
    , ("cursor", "pointer")
    , ("width", "10em")
    --, ("max-width", "40vw")
    , ("font-family", "Gotham-Bold,sans-serif")
    --, ("box-shadow", "inset 0px 0px 0px 10px " ++ color)
    , ("color", "ivory")
    , ("outline", "none")
    ]

h1Style =
  style
    [ ("font-size", "6vh")
    , ("flex", "1")
    , ("font-family", "Publik,Helvetica,Arial,Nimbus Sans L,Bitstream Vera Sans,sans-serif")
    , ("text-shadow", "2px 2px 20px ivory")
    , ("margin", "0px")
    ]

paragraphStyle =
  style
    [ ("font-size", "3.5vh")
    , ("flex", "5")
    , ("font-family", "arial,sans-serif")
    ]

ideologyBar =
  style
    [ ("width", "10em")
    , ("height", "calc(1em + 2.5vh)")
    , ("display", "flex")
    , ("font-size", "4vh")
    , ("margin-top", "4px")
    ]

jimmieImg =
  style
    [ ("width", "calc(10vw + 10vh)")
    , ("height", "calc(10vw + 10vh)")
    , ("border-radius", "50%")
    , ("margin-top", "10px")
    ]

