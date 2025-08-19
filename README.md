# Fonts to fix country flag emoji on Windows 11

Presumably because they want to ignore any political battles the main Windows 11 emoji font "Segoe UI Emoji" does not include country flags.

This is annoying as you browse the web, because lots of people like to use country flags, particularly on places like BlueSky, Twitter, etc, with 🇦🇺 being rendered as `AU` on Windows 11.

This repo includes fonts with emojis based on the Twemoji SVGs, maintained by [@jdecked](https://github.com/jdecked) at [jdecked/twemoji](https://github.com/jdecked/twemoji), but with a name table that allows it to pretend to Windows programs that they are Segoe UI Emoji. (Note, that this would not be fooling Microsoft, who digitally sign their fonts, but it seems to work none-the-less.)

This works for me on the current Insiders build Version 25H2 (26200.5742) in August 2025.

I personally prefer the Twemoji versions because of the non-wavy flags, as the wavy flags of Apple and Google's Noto Emoji font render poorly when sized small.

I have also included a version of the Twemoji font that has the name table from the Apple Color Emoji font, another commonly used fallback font on the web. Personally, I have both installed, but if you don't have Apple Color Emoji it should always fallback to Segoe UI Emoji on Windows anyway.

There are various browser extensions, user scripts and other hacks that do this, but this way is cleaner and more performant IMHO. I am not the first person to think of this, [@perguto](https://github.com/perguto), for instance, has [Country Flag Emojis for Windows](https://github.com/perguto/Country-Flag-Emojis-for-Windows), based on the Noto Emoji, but lots of people seem to suggest that it is no longer working. Copying the full name table, as shown below, rather than just updating the name, may be the reason this is working better for me?

## Installation

1.  **Download the font:**
    *   [**Segoe UI Emoji with Twemoji 16.0.1.ttf**](https://github.com/quarrel/broken-flag-emojis-win11-twemoji/raw/refs/heads/main/Segoe%20UI%20Emoji%20with%20Twemoji%2016.0.1.ttf)

2.  **Install the font:**
    *   Right-click the downloaded `.ttf` file.
    *   Select **"Install"**. (You may need to click "Show more options" first).

3.  **Restart your applications:**
    *   Close and reopen your web browser and any other applications where you want to see the new emojis. A full reboot may be required in some cases.

## How to generate these for other freely available emoji fonts?

Twemoji fonts aren't for everyone, so how did I make these?

Most browsers do not support SVG fonts, but Windows 11 does. So while you can install an SVG font on your Windows device, the browsers will use a fallback font. This means you cannot use a font like: [Twemoji Color Font](https://github.com/13rac1/twemoji-color-font).

[Mozilla](https://github.com/mozilla/twemoji-colr) started producing COLR/CPAL-based color OpenType font from the [Twitter Twemoji](https://twitter.github.io/twemoji/) efforts, but Twitter have abandoned this, as have Mozilla. [@jdecked](https://github.com/jdecked), who worked on this at Twitter, has since 2023 kept supporting this project at [jdecked/twemoji](https://github.com/jdecked/twemoji). [@win98se](https://github.com/win93se) has had a long standing PR waiting for Mozilla to merge @jdecked's latest 16.0.1 release, but given the length of time, [his fork of the repo](https://github.com/win98se/twemoji-colr) is probably the best source at the moment to build a COLR/CPAL-based color OpenType font based on the latest twemoji release.

I built [Twemoji 16.0.1.ttf](./Twemoji%2016.0.1.ttf) here based on that work.

To pretend this font is the Segoe UI Emoji font I used the font name table from the legit Microsoft version. To extract the name table, I used tools from the amazing [@fonttools](https://github.com/fonttools) folks. [uv](https://docs.astral.sh/uv/getting-started/installation/)/pip and [lots of other packages](https://github.com/fonttools/fonttools?tab=readme-ov-file#installation) are available for them. I used `uv tool install fonttools`.

```
# Dump name table from the font we want to pretend to be
ttx -t "name" -o "emjname.ttx" C:\Windows\Fonts\seguiemj.ttf
# then merge that name table to font you want to use in place of the above font
ttx -o "Segoe UI Emoji with Twemoji 16.0.1.ttf" -m "Twemoji 16.0.1.ttf" emjname.ttx
```

Then follow the installation steps above.

I've included the current name tables for both Apple Color Emoji and Segoe UI Emoji in the repo.

The font file name is immaterial to what Windows perceives the font name to be. This also means you can revert this process by installing the original files from C:\Windows\Fonts\ as they are not overwritten.

## Contributing

If you have another open-source emoji font you would like to see included, please [open an issue](https://github.com/quarrel/ColourFlagEmojis/issues/new) and I'll consider adding it.


--Q
