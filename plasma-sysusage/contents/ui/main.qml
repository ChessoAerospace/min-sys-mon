// SPDX-FileCopyrightText: 2026 cesareb
// SPDX-License-Identifier: GPL-2.0-or-later

import QtQuick
import QtQuick.Layouts

import org.kde.plasma.plasmoid
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami
import org.kde.ksysguard.sensors as Sensors

PlasmoidItem {
    id: root

    readonly property bool showCpu: Plasmoid.configuration.showCpu ?? true
    readonly property bool showRam: Plasmoid.configuration.showRam ?? true
    readonly property bool showGpu0: Plasmoid.configuration.showGpu0 ?? true
    readonly property bool showGpu1: Plasmoid.configuration.showGpu1 ?? true

    Sensors.Sensor {
        id: cpuSensor
        sensorId: "cpu/all/usage"
    }
    Sensors.Sensor {
        id: ramSensor
        sensorId: "memory/physical/usedPercent"
    }

    Sensors.Sensor {
        id: gpu0Sensor
        sensorId: "gpu/gpu0/usage"
    }
    Sensors.Sensor {
        id: gpu0Name
        sensorId: "gpu/gpu0/name"
    }
    Sensors.Sensor {
        id: gpu1Sensor
        sensorId: "gpu/gpu1/usage"
    }
    Sensors.Sensor {
        id: gpu1Name
        sensorId: "gpu/gpu1/name"
    }

    readonly property bool hasGpu0: (gpu0Name.value || "") !== ""
    readonly property bool hasGpu1: (gpu1Name.value || "") !== ""
    readonly property bool gpu0Visible: root.showGpu0 && root.hasGpu0
    readonly property bool gpu1Visible: root.showGpu1 && root.hasGpu1

    function pct(sensor) {
        const v = sensor ? Number(sensor.value) : NaN;
        return isNaN(v) ? "--%" : Math.round(v) + "%";
    }

    function gpuTag(name) {
        if (!name)
            return "GPU";
        return /Radeon RX|Navi|GeForce|RTX|GTX|Radeon PRO|Arc/i.test(name) ? "dGPU" : "iGPU";
    }

    toolTipMainText: i18n("System Usage")
    toolTipSubText: {
        const lines = [];
        if (root.showCpu) {
            lines.push(i18n("CPU: %1", pct(cpuSensor)));
        }
        if (root.showRam) {
            lines.push(i18n("RAM: %1", pct(ramSensor)));
        }
        if (root.gpu0Visible) {
            lines.push(gpuTag(gpu0Name.value) + " (" + gpu0Name.value + "): " + pct(gpu0Sensor));
        }
        if (root.gpu1Visible) {
            lines.push(gpuTag(gpu1Name.value) + " (" + gpu1Name.value + "): " + pct(gpu1Sensor));
        }
        return lines.join("\n");
    }

    component Separator: Rectangle {
        Layout.fillHeight: true
        Layout.topMargin: Kirigami.Units.smallSpacing
        Layout.bottomMargin: Kirigami.Units.smallSpacing
        implicitWidth: 1
        color: Kirigami.Theme.textColor
        opacity: 0.3
    }

    compactRepresentation: RowLayout {
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.Label {
            visible: root.showCpu
            text: "CPU " + pct(cpuSensor)
            font: Kirigami.Theme.defaultFont
        }
        Separator {
            visible: root.showCpu && root.showRam
        }
        PlasmaComponents.Label {
            visible: root.showRam
            text: "RAM " + pct(ramSensor)
            font: Kirigami.Theme.defaultFont
        }
        Separator {
            visible: root.gpu0Visible && (root.showCpu || root.showRam)
        }
        PlasmaComponents.Label {
            visible: root.gpu0Visible
            text: gpuTag(gpu0Name.value) + " " + pct(gpu0Sensor)
            font: Kirigami.Theme.defaultFont
        }
        Separator {
            visible: root.gpu1Visible && (root.showCpu || root.showRam || root.gpu0Visible)
        }
        PlasmaComponents.Label {
            visible: root.gpu1Visible
            text: gpuTag(gpu1Name.value) + " " + pct(gpu1Sensor)
            font: Kirigami.Theme.defaultFont
        }
    }

    fullRepresentation: ColumnLayout {
        Layout.minimumWidth: Kirigami.Units.gridUnit * 14
        spacing: Kirigami.Units.smallSpacing

        PlasmaComponents.Label {
            Layout.fillWidth: true
            visible: root.showCpu
            text: i18n("CPU: %1", pct(cpuSensor))
        }
        PlasmaComponents.ProgressBar {
            Layout.fillWidth: true
            visible: root.showCpu
            from: 0
            to: 100
            value: isNaN(Number(cpuSensor.value)) ? 0 : Number(cpuSensor.value)
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            visible: root.showRam
            text: i18n("RAM: %1", pct(ramSensor))
        }
        PlasmaComponents.ProgressBar {
            Layout.fillWidth: true
            visible: root.showRam
            from: 0
            to: 100
            value: isNaN(Number(ramSensor.value)) ? 0 : Number(ramSensor.value)
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            visible: root.gpu0Visible
            text: gpuTag(gpu0Name.value) + " (" + gpu0Name.value + "): " + pct(gpu0Sensor)
            elide: Text.ElideRight
        }
        PlasmaComponents.ProgressBar {
            Layout.fillWidth: true
            visible: root.gpu0Visible
            from: 0
            to: 100
            value: isNaN(Number(gpu0Sensor.value)) ? 0 : Number(gpu0Sensor.value)
        }

        PlasmaComponents.Label {
            Layout.fillWidth: true
            visible: root.gpu1Visible
            text: gpuTag(gpu1Name.value) + " (" + gpu1Name.value + "): " + pct(gpu1Sensor)
            elide: Text.ElideRight
        }
        PlasmaComponents.ProgressBar {
            Layout.fillWidth: true
            visible: root.gpu1Visible
            from: 0
            to: 100
            value: isNaN(Number(gpu1Sensor.value)) ? 0 : Number(gpu1Sensor.value)
        }
    }
}
