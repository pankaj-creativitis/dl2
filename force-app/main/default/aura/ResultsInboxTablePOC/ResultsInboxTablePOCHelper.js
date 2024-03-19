({
	openOverlayModal: function (component, header, body, footerBtnList, theme, showClose, modalId) {
        component.find('overlayLib').showCustomModal({
            header: header,
            showCloseButton: showClose,
            body: body,
            footer: footerBtnList,
            cssClass: "texture " + theme
        });
    }
})