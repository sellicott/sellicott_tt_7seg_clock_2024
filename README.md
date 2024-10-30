![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflTiny Tapeout Verilog Project Templateows/test/badge.svg) ![](../../workflows/fpga/badge.svg)

# 7-Segment LED Desk Clock: Example Project for Fall 2024 Columbus SSCS/CAS Tiny Tapeout Workshop
For more information about the workshop visit the [chapter website](https://r2.ieee.org/columbus-ssccas/blog/2024/01/14/tiny-tapeout-workshop-announcement/).

- [Read the documentation for project](docs/info.md)

## Project Description

Simple digital clock, displays hours, minutes, and seconds in either a 24h format. The goal for the project is to be a simple demonstration of Verilog concepts while still
producing an interesting final project. The design is broken down into several components that should be filled in by workshop attendees. These are tested using the provided testbenches
for functionality, then assembled into the final design.

Since there are not enough output pins to directly drive a 6x
7-segment displays, the data is shifted out serially using an internal 8-bit shift register.
The shift register drives 6-external 74xx596 shift registers to the displays. Clock and control
signals (`serial_clk`, `serial_latch`) are also used to shift and latch the data into the external 
shift registers respectively. The time can be set using the `hours_set` and `minutes_set` inputs.
If `set_fast` is high, then the the hours or minutes will be incremented at a rate of 5Hz, 
otherwise it will be set at a rate of 2Hz. Note that when setting either the minutes, rolling-over
will not affect the hours setting. If both `hours_set` and `minutes_set` are presssed at the same time
the seconds will be cleared to zero.

## What is Tiny Tapeout?

Tiny Tapeout is an educational project that aims to make it easier and cheaper than ever to get your digital and analog designs manufactured on a real chip.

To learn more and get started, visit https://tinytapeout.com.

## Set up your Verilog project

1. Add your Verilog files to the `src` folder.
2. Edit the [info.yaml](info.yaml) and update information about your project, paying special attention to the `source_files` and `top_module` properties. If you are upgrading an existing Tiny Tapeout project, check out our [online info.yaml migration tool](https://tinytapeout.github.io/tt-yaml-upgrade-tool/).
3. Edit [docs/info.md](docs/info.md) and add a description of your project.
4. Adapt the testbench to your design. See [test/README.md](test/README.md) for more information.

The GitHub action will automatically build the ASIC files using [OpenLane](https://www.zerotoasiccourse.com/terminology/openlane/).

## Enable GitHub actions to build the results page

- [Enabling GitHub Pages](https://tinytapeout.com/faq/#my-github-action-is-failing-on-the-pages-part)

## Resources

- [FAQ](https://tinytapeout.com/faq/)
- [Digital design lessons](https://tinytapeout.com/digital_design/)
- [Learn how semiconductors work](https://tinytapeout.com/siliwiz/)
- [Join the community](https://tinytapeout.com/discord)
- [Build your design locally](https://www.tinytapeout.com/guides/local-hardening/)

## What next?

- [Submit your design to the next shuttle](https://app.tinytapeout.com/).
- Edit [this README](README.md) and explain your design, how it works, and how to test it.
- Share your project on your social network of choice:
  - LinkedIn [#tinytapeout](https://www.linkedin.com/search/results/content/?keywords=%23tinytapeout) [@TinyTapeout](https://www.linkedin.com/company/100708654/)
  - Mastodon [#tinytapeout](https://chaos.social/tags/tinytapeout) [@matthewvenn](https://chaos.social/@matthewvenn)
  - X (formerly Twitter) [#tinytapeout](https://twitter.com/hashtag/tinytapeout) [@tinytapeout](https://twitter.com/tinytapeout)
