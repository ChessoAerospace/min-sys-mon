// SPDX-FileCopyrightText: 2026 cesareb
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Controls as QQC2

import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

Kirigami.FormLayout {
    id: page

    property bool cfg_showCpu: true
    property bool cfg_showRam: true
    property bool cfg_showGpu0: true
    property bool cfg_showGpu1: true

    Sensors.Sensor {
        id: gpu0Name
        sensorId: "gpu/gpu0/name"
    }
    Sensors.Sensor {
        id: gpu1Name
        sensorId: "gpu/gpu1/name"
    }

    function gpuLabel(name, fallback) {
        if (!name)
            return fallback;
        return /Radeon RX|Navi|GeForce|RTX|GTX|Radeon PRO|Arc/i.test(name)
            ? i18n("Discrete GPU")
            : i18n("Integrated GPU");
    }

    QQC2.CheckBox {
        Kirigami.FormData.label: i18n("Show:")
        text: i18n("CPU")
        checked: page.cfg_showCpu
        onToggled: page.cfg_showCpu = checked
    }
    QQC2.CheckBox {
        text: i18n("RAM")
        checked: page.cfg_showRam
        onToggled: page.cfg_showRam = checked
    }
    QQC2.CheckBox {
        visible: (gpu0Name.value || "") !== ""
        text: page.gpuLabel(gpu0Name.value, i18n("GPU 1"))
        checked: page.cfg_showGpu0
        onToggled: page.cfg_showGpu0 = checked
    }
    QQC2.CheckBox {
        visible: (gpu1Name.value || "") !== ""
        text: page.gpuLabel(gpu1Name.value, i18n("GPU 2"))
        checked: page.cfg_showGpu1
        onToggled: page.cfg_showGpu1 = checked
    }
}
