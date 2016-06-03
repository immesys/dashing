import QtQuick 2.4
import Material 0.3
import Material.ListItems 0.1 as ListItem
import Material.Extras 0.1
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.3
import BOSSWAVE 1.0
import WaveViewer 1.0


Item {
  id : main

  Component {
    id: svc_delegate

    View {
      elevation:1
      Layout.preferredHeight: lay.implicitHeight+dp(40)
      anchors.left:parent.left
      anchors.right:parent.right
      GridLayout {
        id:lay
        anchors.margins: dp(20)
        columns:4
        anchors.fill:parent
        Label {
          style: "title"
          text: modelData.suffix
          Layout.columnSpan:2
          Layout.fillWidth: true
        }
       Label {
         style: "body2"
         text: "Last seen "
       }
        AgeLabel {
          style: "subheading"
          from: modelData.metadata["lastalive"]
        }
        Label {
          style: "body2"
          text: "Metadata:"
          Layout.columnSpan:4
        }
        Repeater {
          model: MetadataModel {
            from: modelData.metadata
            excludeHB: true
          }
          Label {
            style: "body1"
            Layout.columnSpan: 4
            text: key + " -> " + value
          }
        }
      }
    }
  }
  property var bv : []
  Component.onCompleted : {
    BW.createView({
      "ns":["410.dev"],
    },function(err, handle) {
      console.log("creation error:", err);
      console.log("handle:",handle);
      console.log("interfaces: ", handle.interfaces);
      bv = Qt.binding(function(){
        console.log("evaluated binding")
        return handle.interfaces;
      })
      //bv = handle.interfaces;
      //console.log("did not failed to assign");
      //console.log("bv is: ", bv);
    });
  }

  Flickable {
    anchors.fill:parent
    contentWidth: v.width
    contentHeight: v.height
    anchors.margins: dp(20)
    Item {
      id : v
      //elevation: 1
      width: main.width < dp(800) ? dp(800) : main.width - dp(40)
      height: col.implicitHeight
      //height: 1000
      ColumnLayout {
        id: col
        width: v.width

        //anchors.margins: dp(50)
        ListItem.Subheader {
          text: "Available interfaces on 410.dev"
        }
        Repeater {
          id: rep
          delegate: svc_delegate
          model: bv
        }
        Item {
          Layout.fillHeight:true
        }

        // Button {
        //   text : "clickme"
        //   onClicked: {
        //     console.log("click");
        //     BW.createView({
        //       "ns":["scratch.ns"],
        //     },function(err, handle) {
        //       console.log("creation error:", err);
        //       console.log("handle:",handle);
        //       bv = handle;
        //     });
        //   }
        // }
        // Button {
        //   text : "clickme 2"
        //   onClicked: {
        //     console.log("click");
        //     console.log("bv: ", bv);
        //     console.log("interfaces: ", bv.interfaces);
        //     console.log("interfaces0: ", bv.interfaces[0]);
        //     console.log("services:", bv.services);
        //     console.log("interfaces0name: ", bv.interfaces[0].iface);
        //     rep.model = bv.interfaces;
        //
        //   }
        // }
      }
    }

  /*  ColumnLayout {
      anchors.margins: dp(50)
      ListItem.Subheader {
        text: "Available services on 410.dev"
      }
      Repeater {
        model: mod
        delegate: svc_delegate
      }
    }*/
  }


/*
  View {
    elevation: 1
    width:parent.width-dp(100)
    anchors.margins: dp(50)
    anchors.top:parent.top
    anchors.horizontalCenter:parent.horizontalCenter
  }
*/

}
