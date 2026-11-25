UA_Well — набор изображений для экранов (варианты A и B)

svg/              векторные иконки и кольца (24x24, линия 2, #3A37AC)
png/              все PNG @1x/@2x/@3x, прозрачный фон
UA_Well.xcassets  каталог для Xcode: перетащите папку в проект.
                  Иконки (ic_*, tab_*) — Template: цвет задаёт tintColor.
                  Фоны кнопок и карточек имеют настроенное растяжение (slicing):
                  UIImage(named:) вернёт уже растягиваемую картинку.

Фоны (размеры в pt, радиусы = высота/2 у пилюль)
  btn_primary / _pressed / _disabled   основная кнопка, высота 56, растяжение по ширине
  btn_soft    / _pressed / _disabled   мягкая (мятная) кнопка, высота 56
  btn_outline / _pressed / _disabled   контурная кнопка, высота 56
  card_bg / _pressed / _accent         карточка и строка списка, радиус 20, растяжение по обеим осям
  icbtn_bg / _pressed                  круглая кнопка 44x44 (меню, назад, закрыть)
  tabbar_bg                            нижняя панель, высота 68 (тень задайте через layer.shadow*)
  tab_item_selected                    плашка выбранной вкладки, высота 52
  bg_exercise                          градиентный фон экрана упражнения (B2), 393x852
  rings                                кольца «Старт»/логотипа без надписи, 228x228

Какие ресурсы нужны на каких экранах
  1 Загрузка                 rings (надпись UAWell — ваш logo)
  2 Выбор языка              icbtn_bg+ic_menu, rings, card_bg(+_pressed)+ic_forward
  3 Тип помощи               icbtn_bg+ic_back/ic_menu, rings, card_bg+ic_forward
  4 Быстрая помощь           icbtn_bg+ic_back/ic_menu, card_bg+ic_forward
  5 Описание симптома        icbtn_bg+ic_back/ic_menu, btn_primary
  6 Упражнение               icbtn_bg+ic_menu, btn_primary, btn_soft
  7 Упражнение с таймером    rings (кнопка «Старт»), btn_primary, btn_soft
  8 Длительная работа        icbtn_bg+ic_back/ic_menu, card_bg+ic_forward
  9 Профилактика             icbtn_bg+ic_back/ic_menu, card_bg+ic_chevron_down, btn_primary
  B1 Быстрая помощь          card_bg, card_bg_accent, tabbar_bg, tab_item_selected, tab_help/long/prevention/menu
  B2 Упражнение с таймером   bg_exercise, icbtn_bg+ic_close, rings, btn_primary, btn_soft
  B3 Длительная работа       card_bg+ic_forward, tabbar_bg, tab_*
  B4 Профилактика            card_bg+ic_chevron_down, btn_primary, tabbar_bg, tab_*
  B5 Меню                    card_bg+ic_forward (строки), tabbar_bg, tab_*

Swift
  let c = UIColor(red: 0.227, green: 0.216, blue: 0.675, alpha: 1)       // #3A37AC
  button.setBackgroundImage(UIImage(named: "btn_primary"), for: .normal)
  button.setBackgroundImage(UIImage(named: "btn_primary_pressed"), for: .highlighted)
  button.setBackgroundImage(UIImage(named: "btn_primary_disabled"), for: .disabled)
  menuButton.setBackgroundImage(UIImage(named: "icbtn_bg"), for: .normal)
  menuButton.setImage(UIImage(named: "ic_menu"), for: .normal); menuButton.tintColor = c
  tabItem.image = UIImage(named: "tab_help")
Цвет текста: основная кнопка — белый, мягкая и карточки — #24226E, контурная — #3A37AC.
