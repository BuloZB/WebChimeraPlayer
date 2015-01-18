import QtQuick 2.1
import QtQuick.Layouts 1.0
import QmlVlc 0.1
import QtGraphicalEffects 1.0

Rectangle {
	property alias backgroundColor: progressBackground.color
	property alias viewedColor: movepos.color
	property alias positionColor: curpos.color
	property alias dragpos: dragpos
	property alias effectDuration: effect.duration
	property alias cacheVisible: cache.visible
	property alias cacheColor: cache.color
	signal pressed(string mouseX, string mouseY)
	signal changed(string mouseX, string mouseY)
	signal released(string mouseX, string mouseY)
	
	id: root
	anchors.fill: parent
	color: "transparent"
	
	RowLayout {
		id: rowLayer
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.bottomMargin: multiscreen == 1 ? fullscreen ? 32 : -8 : fullscreen ? 32 : mousesurface.containsMouse ? 30 : 0 // Multiscreen - Edit
		opacity: multiscreen == 1 ? fullscreen ? fullscreen ? ismoving > 5 ? 0 : 1 : 1 : 0 : fullscreen ? ismoving > 5 ? 0 : 1 : 1 // Multiscreen - Edit
		Behavior on anchors.bottomMargin {
			PropertyAnimation {
				id: effect
				duration: multiscreen == 0 ? 250 : 0				
			}
		}
		Behavior on opacity { PropertyAnimation { duration: multiscreen == 1 ? fullscreen ? 250 : 0 : 250 } }
		
		// Start Progress Bar Functionality (Time Chat Bubble, Seek)
		MouseArea {
			id: dragpos
			cursorShape: toolbar.opacity == 1 ? Qt.PointingHandCursor : mousesurface.cursorShape
			hoverEnabled: true
			anchors.fill: parent
			onPressed: root.pressed(mouse.x,mouse.y);
			onPositionChanged: root.changed(mouse.x,mouse.y);
			onReleased: root.released(mouse.x,mouse.y);
		}
		Rectangle {
			id: progressBackground
			Layout.fillWidth: true
			height: 8
			anchors.verticalCenter: parent.verticalCenter
			Rectangle {
				id: cache
				visible: false
				height: 8
				anchors.left: parent.left
				anchors.bottom: parent.bottom
				color: "#3E3E3E"
				width: vlcPlayer.state <= 1 ? 0 : dragging ? 0 : ((parent.width - anchors.leftMargin - anchors.rightMargin) * vlcPlayer.position) + ((parent.width - anchors.leftMargin - anchors.rightMargin) * ((caching / ((vlcPlayer.time * (1 / vlcPlayer.position)) /100)) /100) /100 * buffering)
//				Behavior on width { PropertyAnimation { duration: dragging ? 0 : vlcPlayer.time - lastTime > 0 ? vlcPlayer.time - lastTime : 0 } }
			}
			Rectangle {
				id: movepos
				width: vlcPlayer.state <= 1 ? 0 : dragging ? dragpos.mouseX -4 : (parent.width - anchors.leftMargin - anchors.rightMargin) * vlcPlayer.position
				anchors.top: parent.top
				anchors.left: parent.left
				anchors.bottom: parent.bottom
//				Behavior on width { PropertyAnimation { duration: dragging ? 0 : vlcPlayer.time - lastTime > 0 ? vlcPlayer.time - lastTime : 0 } }
			}
		}
		// End Progress Bar Functionality (Time Chat Bubble, Seek)
	}
	RowLayout {
		id: movecur
		spacing: 0
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.bottom: parent.bottom
		anchors.leftMargin: vlcPlayer.state <= 1 ? 0 : dragging ? dragpos.mouseX -4 > 0 ? dragpos.mouseX < parent.width -4 ? dragpos.mouseX -4 : parent.width -8 : 0 : (parent.width - anchors.rightMargin) * vlcPlayer.position > 0 ? (parent.width - anchors.rightMargin) * vlcPlayer.position < parent.width -8 ? (parent.width - anchors.rightMargin) * vlcPlayer.position : parent.width -8 : 0
		
		// Start Multiscreen - Edit
		anchors.bottomMargin: multiscreen == 1 ? fullscreen ? toolbar.height : -16 : fullscreen ? toolbar.height : mousesurface.containsMouse ? toolbar.height : 0
		opacity: multiscreen == 1 ? fullscreen ? ismoving > 5 ? 0 : 1 : 0 : fullscreen ? ismoving > 5 ? 0 : 1 : 1
		// End Multiscreen - Edit

//		Behavior on anchors.leftMargin { PropertyAnimation { duration: dragging ? 0 : vlcPlayer.time - lastTime > 0 ? vlcPlayer.time - lastTime : 0 } }
		Behavior on anchors.bottomMargin { PropertyAnimation { duration: multiscreen == 1 ? 0 : 250 } }
		Behavior on opacity { PropertyAnimation { duration: 250 } }
		Rectangle {
			Layout.fillWidth: true
			height: 8
			color: 'transparent'
			anchors.verticalCenter: parent.verticalCenter
			Rectangle {
				id: shadowEffect
				color: fullscreen ? Qt.rgba(0, 0, 0, 0.3) : mousesurface.containsMouse ? Qt.rgba(0, 0, 0, 0.3) : Qt.rgba(0, 0, 0, 0.2)
				height: fullscreen ? 16 : mousesurface.containsMouse ? 16 : 10
				width: fullscreen ? 16 : mousesurface.containsMouse ? 16 : 10
				radius: width == 10 ? 0 : width * 0.5
				anchors.bottom: parent.bottom
				anchors.bottomMargin: fullscreen ? -4 : mousesurface.containsMouse ? -4 : -2
				anchors.left: parent.left
				anchors.leftMargin: fullscreen ? -4 : mousesurface.containsMouse ? -4 : -1
				Behavior on anchors.bottomMargin { PropertyAnimation { duration: 250 } }
				Behavior on anchors.leftMargin { PropertyAnimation { duration: 250 } }
				Behavior on width { PropertyAnimation { duration: 250 } }
				Behavior on height { PropertyAnimation { duration: 250 } }
				Behavior on color { PropertyAnimation { duration: 250 } }
			}
			Rectangle {
				id: curpos
				height: fullscreen ? 14 : mousesurface.containsMouse ? 14 : 8
				width: fullscreen ? 14 : mousesurface.containsMouse ? 14 : 8
				radius: width == 8 ? 0 : width * 0.5
				anchors.bottom: parent.bottom
				anchors.bottomMargin: fullscreen ? -3 : mousesurface.containsMouse ? -3 : 0
				anchors.left: parent.left
				anchors.leftMargin: fullscreen ? -3 : mousesurface.containsMouse ? -3 : 0
				Behavior on anchors.bottomMargin { PropertyAnimation { duration: 250 } }
				Behavior on anchors.leftMargin { PropertyAnimation { duration: 250 } }
				Behavior on width { PropertyAnimation { duration: 250 } }
				Behavior on height { PropertyAnimation { duration: 250 } }		
				Rectangle {
					height: fullscreen ? 6 : mousesurface.containsMouse ? 6 : 0
					width: fullscreen ? 6 : mousesurface.containsMouse ? 6 : 0
					radius: width * 0.5
					anchors.centerIn: parent
					color: cache.visible ? cache.color : progressBackground.color
					Behavior on width { PropertyAnimation { duration: 250 } }
					Behavior on height { PropertyAnimation { duration: 250 } }
				}
			}
		}
	}
}