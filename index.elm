import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html.Attributes exposing (..)

main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL

type alias Model =
  { content : List (Html Msg)
  , result : List Ideology
  }

model : Model
model = Model content []


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
    "På vinden så har du flera tidsskriftshållare fyllda med..."
    (Answer Left "Bamse - Världens snällaste björn")
    (Answer Right "Don Rosas samlade verk")

question4 : Question
question4 =
  Question
    "Vilken sida tänkte du lägga din röst på i valet 9:e september?"
    (Answer Left "Vänstern")
    (Answer Right "Högern")

blue : String
blue = "rgb(0, 106, 179)"

red : String
red = "rgb(237, 27, 52)"

-- UPDATE

type Msg
  = Reset
  | AddAnswer Ideology
  | Start
  | Redo


update : Msg -> Model -> Model
update msg model =
  case msg of
    Reset -> model
    AddAnswer ideology ->
      Debug.log (toString model.result)
      { model
      | result = ideology :: model.result
      , content = Maybe.withDefault [] (List.tail model.content)
      }
    Start ->
      { model | content = Maybe.withDefault [] (List.tail model.content) }
    Redo -> Model content []


-- VIEW

view : Model -> Html Msg
view model =
  div [ container ]
  [ resultBox model.result
  , Maybe.withDefault (div [] []) (List.head model.content)
  ]

frontBox : Html Msg
frontBox =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass 2018" ]
  , Html.h2 [ h2Style ] [ text "Gör Aimans Valkompass 2018 och ta reda på vilket parti du borde rösta på i valet 2018!" ]
  , div [ boxContainer ]
    [ button [ onClick Start, buttonStyle "green" ] [ text "Start" ]
    ]
  ]

resultBox : List Ideology -> Html Msg
resultBox result =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass 2018" ]
  , div [ boxContainer ] [(resultToBar result)]
  , Html.h2 [ h2Style ] [ text (resultToText result) ]
  , div [ boxContainer ]
    [ button [ onClick Redo, buttonStyle "green" ] [ text "Gör om" ]
    ]
  ]

questionBox : Question -> Html Msg
questionBox q =
  div [ box ]
  [ Html.h1 [ h1Style ] [ text "Aimans Valkompass 2018" ]
  , Html.h2 [ h2Style ] [ text q.question ]
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
      "Du är helt klart vänster, kamrat! Aimans Valkompass föreslår därför att du röstar på ett parti på den vänstra halvan av spektrumet, till exempel V, MP eller kanske rent av S."
    [ Left, Left, Left, Right ] ->
      "Du är mestadels röd, men verkar ändå besitta en respekt för marknadens läkande krafter. S och MP kan ju vara en grej, men en proteströst på V kan också gå hem."
    [ Left, Left, Right, Right ] ->
      "Det är omöjligt att placera dig helt klockrent på Höger/Vänster-skalan. Du svajar helt enkelt för mycket i din ideologi. Statistiskt sett så borde du rösta på S, men M går också bra."
    [ Left, Right, Right, Right ] ->
      "Du är lika blå som röda havet. C, M och Birgitta Ohlsson-L skulle kunna vara ett nyktert val för din del."
    [ Right, Right, Right, Right ] ->
      "Du är uppenbart genomblå! Alliansen har allt som du någonsin kan önska."
    _ ->
      "Data saknas för att kunna avgöra din politiska hållning."

resultToBar : List Ideology -> Html Msg
resultToBar list =
  div [ ideologyBar ] (List.map
    (\x -> if x == Left
      then div [ style [ ("background-color", red) , ("height", "100%"), ("flex", "1") ] ] []
      else div [ style [ ("background-color", blue), ("height", "100%"), ("flex", "1") ] ] []
      ) (sortIdeology list)
    )

sortIdeology : List Ideology -> List Ideology
sortIdeology list =
  case list of
    [] -> []
    Left :: tail ->
      Left :: sortIdeology tail
    Right :: tail ->
      (sortIdeology tail) ++ [Right]

-- STYLE

container = 
  style
    [ ("background-color", "purple")
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
    , ("background-color", "orange")
    , ("border", "1px solid black")
    , ("box-shadow", "0 0 50px black")
    , ("border-radius", "5px")
    , ("text-align", "center")
    , ("position", "absolute")
    , ("top", "50%")
    , ("left", "50%")
    , ("transform", "translate(-50%, -50%)")
    , ("display", "flex")
    , ("flex-direction", "column")
    , ("justify-content", "space-between")
    ]

buttonStyle color =
  style
    [ ("font-size", "5vh")
    , ("border", "4px solid black")
    , ("background-color", "ivory")
    , ("border-radius", "8px")
    , ("margin", "15px")
    , ("padding", "10px 20px")
    , ("cursor", "pointer")
    , ("min-width", "20vw")
    , ("max-width", "40vw")
    , ("font-family", "Gotham-Bold,sans-serif")
    , ("box-shadow", "inset 0px 0px 0px 10px " ++ color)
    ]

h1Style =
  style
    [ ("font-size", "6vh")
    , ("flex", "1")
    , ("font-family", "Publik,Helvetica,Arial,Nimbus Sans L,Bitstream Vera Sans,sans-serif")
    , ("text-shadow", "2px 2px 20px ivory")
    , ("margin", "0px")
    ]

h2Style =
  style
    [ ("font-size", "3.5vh")
    , ("flex", "5")
    , ("font-family", "arial,sans-serif")
    ]

ideologyBar =
  style
    [ ("width", "15em")
    , ("height", "2em")
    , ("border", "1px solid black")
    , ("display", "flex")
    ]
