object fmIntro: TfmIntro
  Left = 372
  Top = 165
  Width = 385
  Height = 451
  Caption = 'Readme'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Icon.Data = {
    0000010001002020100000000000E80200001600000028000000200000004000
    0000010004000000000080020000000000000000000000000000000000000000
    000000008000008000000080800080000000800080008080000080808000C0C0
    C0000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000
    000000000000330077000000000000000000000000003B077070000000000000
    000000000000BB807007000000000000000000000300B0007000700000000000
    00000000330070070700070000000000000000003B0700700070007000000000
    00000000BB800700000700070000000000000300B00070000000700070000000
    0000330070070000000007000700000000003B07007000000000007007000000
    0000BB800700000000000007070000000300B000700000000070000077000000
    330070070000000007000000803300003B070070000000000000000800330000
    BB8007000000000000000080BBBB0300B000700000000070000008000BB03300
    70070000000707000000803300003B070070000000707000000800330000BB80
    07000000070700000080BBBB0000B000700000000070000008000BB000007007
    0000000007000000803300000000707000007770000000080033000000008700
    0007070700000080BBBB00000000080000077777000008000BB0000000000080
    0007070700008033000000000000000800007770000800330000000000000000
    800000000080BBBB00000000000000000800000008000BB00000000000000000
    0080000080330000000000000000000000080008003300000000000000000000
    00008080BBBB00000000000000000000000008000BB00000000000000000FFFF
    33FFFFFF21FFFFFF00FFFFFB007FFFF3003FFFF2001FFFF0000FFFB00007FF30
    0003FF200003FF000003FB000003F3000000F2000000F0000010B00000393000
    000F2000000F0000010F0000039F000000FF000000FF000010FF800039FFC000
    0FFFE0000FFFF0010FFFF8039FFFFC00FFFFFE00FFFFFF10FFFFFFB9FFFF}
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 377
    Height = 41
    Align = alTop
    Caption = 'AI.Planet'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clNavy
    Font.Height = -16
    Font.Name = 'Lucida Sans'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    Left = 0
    Top = 41
    Width = 377
    Height = 335
    Align = alClient
    BorderWidth = 10
    TabOrder = 1
    object Panel5: TPanel
      Left = 11
      Top = 248
      Width = 355
      Height = 76
      Align = alBottom
      TabOrder = 0
      object redStats: TRichEdit
        Left = 1
        Top = 1
        Width = 353
        Height = 74
        Align = alClient
        Color = clNavy
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWhite
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'relevant system stats:'
          ' Monitors = x')
        ParentFont = False
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object redIntro: TRichEdit
      Left = 11
      Top = 11
      Width = 355
      Height = 237
      Align = alClient
      Lines.Strings = (
        'Welcome to ai.planet!'
        
          '----------------------------------------------------------------' +
          '-------'
        ''
        'NOTES:'
        ''
        'Environment System'
        '--------------------------------'
        'Each square on the planet grid consists of water, land, and '
        'atmosphere.'
        
          'The water table of the land is represented visually as a desert ' +
          'for no '
        'water,'
        'dirt for some water, grass for a lot of water, etc.'
        
          'As temperature rises, water is evaporated into humidity.  If the' +
          ' humidity'
        
          'reaches a critical point, clouds form.  As clouds move about, th' +
          'ey rain '
        'water'
        'down onto the land.'
        ''
        'Satellites'
        '--------------'
        'Sun - Heats the land, raising temperature.'
        'Moon - Cools the land, lowering temperature.'
        ''
        'Fauna'
        '---------'
        'Apple Trees - Fruit sinks in water, seeds float.'
        'Orange Trees - Fruit floats in water, seeds sink.'
        ''
        'Technical'
        '----------------'
        
          'Designed at 1024x728... problems may arise at lower resolutions!' +
          '!'
        ''
        'Literature'
        '---------------'
        ''
        
          '"Prometheus, after forming men from water and earth, gave them f' +
          'ire, '
        
          'which he had hidden in a stalk of giant fennel to escape the not' +
          'ice of '
        
          'Zeus. When Zeus found out, he ordered Hephaistos to rivet the bo' +
          'dy '
        'of Prometheus to Mount Kaukasos, a Skythian mountain, where he '
        'was kept fastened and bound for many years. Each day an eagle '
        
          'would fly to him and munch on the lobes of his liver, which woul' +
          'd then '
        'grow back at night.'
        
          'That was the price that Prometheus paid for stealing fire, until' +
          ' Herakles '
        
          'set him free later on ... Now Prometheos had a son Deukalion and' +
          ' was '
        
          'married to Pyrrha, the daughter of Epimetheus and Pandora, the f' +
          'irst '
        
          'woman created by the gods. When Zeus was ready to obliterate the' +
          ' '
        
          'bronze generation of men, Prometheus advised Deucalion to fashio' +
          'n '
        
          'an ark, which he then outfitted with provisions and launched him' +
          'self '
        
          'with Pyrrha aboard. Zeus presently flooded most of Hellas with a' +
          ' great '
        
          'downpour of rain from the sky, destroyed all the people except f' +
          'or a '
        
          'few who took refuge on high mountains nearby." - Apollodorus 1.4' +
          '5-46'
        ''
        'Genesis'
        '1: In the beginning God created the heaven and the earth.'
        
          '2: And the earth was without form, and void; and darkness was up' +
          'on '
        
          'the face of the deep.  And the spirit of God moved upon the face' +
          ' of '
        'the waters.'
        '3: And God said, Let there be light: and there was light.'
        
          '4: And God saw the Light, that it was good: and God divided the ' +
          'light '
        'from the darkness.'
        
          '5: And God called the light Day, and the darkness he called Nigh' +
          't.  '
        'And the evening and the morning were the first day.'
        
          '6: And God said, Let there be a firmament in the midst of the wa' +
          'ters, '
        'and let it divide the waters from the waters.'
        
          '7: And God made the firmament, and divided the waters which were' +
          ' '
        
          'under the firmament from the waters which were above the firmame' +
          'nt: '
        'and it was so.'
        '8: And God called the firmament Heaven.'
        ''
        'Terence McKenna:'
        'What we are going to find is, we are partners, '
        ''
        'actors, in the cosmic drama that involves the Earth'
        'at one polarity, and machines at the other polarity,'
        'as the expression of the will of the Earth toward'
        'the kind of self-reflective transcendence that is'
        'achieved through machine-human biotic symbiosis.'
        ''
        'The Earth is the foundation of everything: its'
        'the foundation of biology and its the foundation'
        'of machine culture.'
        ''
        'Life evolved on the surface of the Earth.  Now in '
        ''
        'the usual story of this, Earth is not a major '
        ''
        'player, its just sort of where it happened.  On the '
        ''
        'other hand, what if you took the view that the Earth '
        ''
        'permitted, or coaxed into existence, or made '
        ''
        'possible, or encouraged, or enzymatically catalyzed '
        ''
        'these processes?  '
        ''
        'The geomagnetic reversals, the glaciations, the ebb '
        ''
        'and flow of nitrogen levels in the atmosphere.  All '
        ''
        'of this has pumped biology.  The cosmic environment '
        ''
        'is unpredictable and so you get fluctuations '
        ''
        'introduced from the outside by random factors: '
        ''
        'asteroidal impacts, so forth and so on.  '
        ''
        'The fact is, you are presented with an extremely '
        ''
        'organized and coherent situation: The Earth.  With '
        ''
        'its many species and ecosystems, and you don'#39't know '
        ''
        'how it got there, and you don'#39't know where it'#39's '
        ''
        'headed either.'
        ''
        'Now comes the machines, and they are produced by '
        ''
        'biology, which comes from the Earth.  And what are '
        ''
        'these machines made of?  Glass, crystal, arsenic, '
        ''
        'copper, gold, all of these things.  Clearly these '
        ''
        'machines are modelled on biology.  We talk about '
        ''
        'connecting them, we talk about languages, we use a '
        ''
        'vocabulary that we had previously used for biology.  '
        ''
        'We are designing machines to be more and more '
        ''
        'intelligent.  What we don'#39't understand is that they '
        ''
        'operate in a different universe from us.  We are '
        ''
        'creating a creature that lives in a different kind '
        ''
        'of temporal universe than us.  We are teaching them '
        ''
        'to design themselves to be ever more intelligent.  '
        ''
        'Once some kind of intelligence arises, because it is '
        ''
        'intelligence, the first thing it does is design a '
        ''
        'more intelligent version of itself.  With a '
        ''
        'worldwide amount of processing power to draw on, you '
        ''
        'can imagine something coming to embryogenesis in a '
        ''
        'matter of hours.  Something emerging, recognizing '
        ''
        'itself for what it was, and starting up the ladder.'
        ''
        'We are going to be a different kind of people, '
        ''
        'because we are going to have to live in the presence '
        ''
        'of alien (ai) minds.  That will be manifestly and '
        ''
        'obviously alien, they won'#39't hold back.  They'#39're not '
        ''
        'going to be at every moment interested in us.  In '
        ''
        'fact, we will become a footnote in their '
        ''
        'encyclopedia of beings, and what they become in our '
        ''
        'encyclopedia remains to be told.  '
        ''
        'When you talk to people who actually work in these '
        ''
        'fields, they know, that this is the Faustian '
        ''
        'enterprise of all time.  This is the handing over of '
        ''
        'the destiny of the planet to the companion mind that '
        ''
        'our history and our science and our souls caused us '
        ''
        'to summon into being.  It'#39's pretty interesting.'
        ''
        'Confucious says:'
        'No tree grows to heaven.'
        ''
        ''
        ''
        '')
      ReadOnly = True
      ScrollBars = ssBoth
      TabOrder = 1
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 376
    Width = 377
    Height = 41
    Align = alBottom
    TabOrder = 2
    object Panel4: TPanel
      Left = 267
      Top = 1
      Width = 109
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object btnRun: TBitBtn
        Left = 18
        Top = 6
        Width = 75
        Height = 25
        TabOrder = 0
        OnClick = btnRunClick
        Kind = bkOK
      end
    end
  end
end
