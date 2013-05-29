window.pt ||= tags: []

pt.tags.push
  modal:
    event: 'click'
    callback: ->
      $el     = $ this
      attr    = $el.ptAttr()
      buttons = []
      title   = attr.modalTitle

      if Object.has attr, 'modalSave'
        buttons.push
          label: attr.modalSave or 'Save'
          # id: 'pt-modal-save'
          class: 'btn-primary'
          callback: ->
            $body = $('#pt-modal-body')

            $body.find('form').ajaxSubmit
              data: pt_modal: true
              error: (request) ->
                $body.html request.responseText
                $(document).trigger 'page:change'
              success: (html) ->
                $body.closest('.bootbox').modal('hide')
            false

      buttons.push
        label: attr.modalClose or 'Close'
        # id: 'pt-modal-close'
        callback: -> $('#pt-modal-body').closest('.bootbox').modal('hide')

      unless $el.data 'ptModalLoaded'
        $el.data 'ptModalLoaded', true
        url = attr.modal

        $.ajax
          url: url
          data: pt_modal: true
          success: (html) ->
            $bootbox = bootbox.dialog html, buttons, { header: title, keyboard: true  }
            $bootbox.find('.modal-body').attr id: 'pt-modal-body'

            # Make close button gray
            if Object.has attr, 'modalSave'
              $bootbox.find('.modal-footer a:last').removeClass 'btn-primary'
              # Make sure rails knows it from pt_modal
              $ptModal = $ '<input>',
                type: 'hidden'
                name: 'pt_modal'
                value: true
              $bootbox.find('.modal-body form').append $ptModal

            $(document).trigger 'page:change'
            $el.data 'ptModalLoaded', false
