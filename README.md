# Minimalistic Hardware Usage Monitor

A small CPU / RAM / GPU readout for the Plasma 6 panel.

The panel shows the current values in a single row:

CPU 3% │ RAM 24% │ dGPU 6% │ iGPU 0%

Clicking the widget opens a popup with the same values as progress bars, and hovering shows the full GPU model names in the tooltip.

The GPU readings are labelled by type: the discrete card is shown as dGPU and the integrated one as iGPU, based on the device name reported by ksystemstats. A machine with a single GPU only shows that one.

Right-click the widget and choose Configure to pick which readings are shown. Each of CPU, RAM and the GPUs can be turned off, and the separators adjust to whatever is left on.
Requirements

Plasma 6 with ksystemstats. On most distributions this comes in with plasma-workspace, so there is usually nothing extra to install.
Install

From a release package:

kpackagetool6 --type Plasma/Applet --install com.cesareb.sysusage.plasmoid

From a git clone:

kpackagetool6 --type Plasma/Applet --install .

Then right-click the panel, pick Add Widgets and search for "System Usage".

Updates are done the same way with --upgrade instead of --install. If the widget is already on a panel, restart plasmashell to pick up the changes.
Building the package

zip -r com.cesareb.sysusage.plasmoid metadata.json contents

License

GPL-2.0-or-later. See LICENSE.
