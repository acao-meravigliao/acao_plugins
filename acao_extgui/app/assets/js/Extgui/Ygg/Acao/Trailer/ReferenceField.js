/*
 * Copyright (C) 2017-2018, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Trailer.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Trailer',
    'Extgui.Ygg.Acao.Trailer',
    'Extgui.Ygg.Acao.Trailer.Picker',
  ],
  alias: 'widget.acao_trailer',

  extguiObject: 'Extgui.Ygg.Acao.Trailer',
  pickerClass: 'Extgui.Ygg.Acao.Trailer.Picker',
});
