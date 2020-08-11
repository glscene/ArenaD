object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'FBO Renderer'
  ClientHeight = 478
  ClientWidth = 504
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object GLSceneViewer1: TGLSceneViewer
    Left = 0
    Top = 0
    Width = 504
    Height = 478
    Camera = GLCamera1
    Buffer.BackgroundColor = clBlack
    Buffer.AntiAliasing = aaNone
    FieldOfView = 156.367706298828100000
    PenAsTouch = False
    Align = alClient
    TabOrder = 0
  end
  object GLScene1: TGLScene
    Left = 32
    Top = 24
    object GLCamera1: TGLCamera
      DepthOfView = 100.000000000000000000
      FocalLength = 50.000000000000000000
      NearPlaneBias = 0.100000001490116100
      TargetObject = GLTeapot1
      CameraStyle = csInfinitePerspective
      Position.Coordinates = {0000C03F0000C03F0000C03F0000803F}
      object GLLightSource1: TGLLightSource
        ConstAttenuation = 1.000000000000000000
        Specular.Color = {0000803F0000803F0000803F0000803F}
        SpotCutOff = 180.000000000000000000
      end
    end
    object GLFBORenderer1: TGLFBORenderer
      Width = 512
      Height = 512
      ColorTextureName = 'colorTex'
      MaterialLibrary = GLMaterialLibrary1
      BackgroundColor.Color = {0000003F0000003F0000003F0000803F}
      ClearOptions = [coColorBufferClear, coDepthBufferClear, coStencilBufferClear, coUseBufferBackground]
      Camera = GLCamera1
      SceneScaleFactor = 512.000000000000000000
      RootObject = GLTeapot1
      TargetVisibility = tvFBOOnly
      EnabledRenderBuffers = [erbDepth]
    end
    object GLTeapot1: TGLTeapot
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'Enamel'
      Scale.Coordinates = {00000040000000400000004000000000}
    end
    object GLHUDSprite1: TGLHUDSprite
      Material.MaterialLibrary = GLMaterialLibrary1
      Material.LibMaterialName = 'colorTex'
      Position.Coordinates = {0000804300008043000000000000803F}
      Width = 512.000000000000000000
      Height = 512.000000000000000000
      Rotation = 0.000000000000000000
    end
  end
  object GLCadencer1: TGLCadencer
    Left = 32
    Top = 88
  end
  object GLMaterialLibrary1: TGLMaterialLibrary
    Materials = <
      item
        Name = 'Enamel'
        Tag = 0
        Material.FrontProperties.Diffuse.Color = {0000803FCDCCCC3DCDCCCC3D0000803F}
        Material.FrontProperties.Shininess = 60
        Material.FrontProperties.Specular.Color = {0000803F0000803F0000803F0000803F}
        Material.FaceCulling = fcNoCull
      end
      item
        Name = 'colorTex'
        Tag = 0
        Material.MaterialOptions = [moIgnoreFog, moNoLighting]
        Material.Texture.ImageClassName = 'TGLBlankImage'
        Material.Texture.Image.ColorFormat = 6408
        Material.Texture.TextureWrap = twSeparate
        Material.Texture.TextureWrapS = twClampToEdge
        Material.Texture.TextureWrapT = twClampToEdge
        Material.Texture.TextureWrapR = twClampToEdge
        Material.Texture.Disabled = False
        Shader = GLSLShader1
      end>
    Left = 120
    Top = 24
  end
  object GLSimpleNavigation1: TGLSimpleNavigation
    Form = Owner
    GLSceneViewer = GLSceneViewer1
    FormCaption = 'CUDA Post Processing  For OpenGL - %FPS'
    KeyCombinations = <
      item
        ShiftState = [ssLeft, ssRight]
        Action = snaZoom
      end
      item
        ShiftState = [ssLeft]
        Action = snaMoveAroundTarget
      end
      item
        ShiftState = [ssRight]
        Action = snaMoveAroundTarget
      end>
    Left = 32
    Top = 144
  end
  object GLSLShader1: TGLSLShader
    Enabled = False
    FragmentProgram.Code.Strings = (
      '#version 120'
      'uniform float blur_dist;'
      'uniform sampler2D RT;'
      ''
      '    void main(void)                                '
      '    {                                              '
      '     vec2 samples00 = vec2(-0.326212, -0.405805);  '
      '     vec2 samples01 = vec2(-0.840144, -0.073580);  '
      '     vec2 samples02 = vec2(-0.695914,  0.457137);  '
      '     vec2 samples03 = vec2(-0.203345,  0.620716);  '
      '     vec2 samples04 = vec2( 0.962340, -0.194983);  '
      '     vec2 samples05 = vec2( 0.473434, -0.480026);  '
      '     vec2 samples06 = vec2( 0.519456,  0.767022);  '
      '     vec2 samples07 = vec2( 0.185461, -0.893124);  '
      '     vec2 samples08 = vec2( 0.507431,  0.064425);  '
      '     vec2 samples09 = vec2( 0.896420,  0.412458);  '
      '     vec2 samples10 = vec2(-0.321940, -0.932615);  '
      '     vec2 samples11 = vec2(-0.791559, -0.597705);  '
      '     vec2 newCoord;                                '
      
        '     vec4 sum = texture2D(RT, gl_TexCoord[0].st);               ' +
        ' '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples00;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples01;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples02;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples03;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples04;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples05;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples06;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples07;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples08;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples09;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples10;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      
        '     newCoord = gl_TexCoord[0].st + blur_dist * samples11;      ' +
        ' '
      '     sum += texture2D(RT, newCoord);               '
      '     sum /= 13.0;                                  '
      '     gl_FragColor = vec4(sum.rgb,  1.0);                     '
      '    } ')
    FragmentProgram.Enabled = True
    OnApply = GLSLShader1Apply
    FailedInitAction = fiaReRaiseException
    Left = 120
    Top = 88
  end
end
