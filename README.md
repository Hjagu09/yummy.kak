# YUMMY.kak

![Screenshot from 2024-03-16 14-00-13](https://github.com/Hjagu09/yummy.kak/assets/110788066/79152ab2-0d11-4a00-a590-6679ac383e1a)
![yummy_dev_config](https://github.com/Hjagu09/yummy.kak/assets/110788066/e8c996ad-d3ab-4ee5-928a-1da7bec0e9b9)
![yummy_powerline_left](https://github.com/Hjagu09/yummy.kak/assets/110788066/38b5d411-3612-4ccf-9813-006d9790d0a0)
![yummy_std_config](https://github.com/Hjagu09/yummy.kak/assets/110788066/2ac204a7-9c8b-430e-9ad0-df2408587e3c)
![Screenshot from 2024-03-16 14-02-36](https://github.com/Hjagu09/yummy.kak/assets/110788066/e30920f7-991b-4138-b738-b9b6d905e882)

Yummy.kak is a modeline for kakoune that renders a beutiful bar. It has the option to either be pined to the rigth (kakoune defualt) or fill the whole width of the screen. It's configured via two simpel format strings and a dozen kakoune faces and options.

## Instalation
Put the yummy.kak and yummy_configs.kak script in your autoload or install it using a plugin maneger and then put this in your kakrc as a config base line:
```kak
require-module yummy_std_config
yummy-enable
```

## configuring
The main variables used for configuration is yummy_fmt_left and yummy_fmt_rigth. there exactly what you think they are, the format of the left and right side of the bar. They may contain module names preceded by a dollar sign and free text that's to be rendered using the StatusLine face. Valid modules are:

+ **mode:** the current mode, insert/normal
+ **bufname:** name of the current buffer
+ **modified:** text icon that appears while the buffer has unwritten changes
+ **clock:** a clock. could also be used to display the current date
+ **client_servee:** displays the current client and server names
+ **selection:** selection location and count

All modules expected mode are rendered with the face yummy_[module name]_face. All faces are buy default derived from the standard kakoune status line faces. Some modules also expose additional options to customize them.

+ mode exposes two options for the text shown in insert/normal mode. It also exposes two faces for use for rendering in normal/insert mode
+ bufname exposes the SH string used to generate it
+ modified exposes a option for the text icon used and also a option for the SH string used to render the module
+ the clock module exposes the time format. This is passed to the command line date to get the current time
+ client_server and selections exposes one SH string each used to render them

## example configurations
yummy_configs.kak contain a few example config. Feel free to use them as is or look at them for reference.

**yummy_powerline_config**
![Screenshot from 2024-03-16 14-00-13](https://github.com/Hjagu09/yummy.kak/assets/110788066/79152ab2-0d11-4a00-a590-6679ac383e1a)
**yummy_devs_config** This is my config :). It's the only one that hard codes colors
![yummy_dev_config](https://github.com/Hjagu09/yummy.kak/assets/110788066/e8c996ad-d3ab-4ee5-928a-1da7bec0e9b9)
**yumy_powerline_left_config** Powerline but to the left
![yummy_powerline_left](https://github.com/Hjagu09/yummy.kak/assets/110788066/38b5d411-3612-4ccf-9813-006d9790d0a0)
**yummy_std_config** kinda boring simple example config
![yummy_std_config](https://github.com/Hjagu09/yummy.kak/assets/110788066/2ac204a7-9c8b-430e-9ad0-df2408587e3c)
**yummy_the_rigth_side_config** simpel one side config
![Screenshot from 2024-03-16 14-02-36](https://github.com/Hjagu09/yummy.kak/assets/110788066/e30920f7-991b-4138-b738-b9b6d905e882)
