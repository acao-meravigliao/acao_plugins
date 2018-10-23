/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Club.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Club',
    'Extgui.Ygg.Acao.Club',
    'Extgui.Ygg.Acao.Club.Picker',
  ],
  alias: 'widget.acao_club',

  extguiObject: 'Extgui.Ygg.Acao.Club',
  pickerClass: 'Extgui.Ygg.Acao.Club.Picker',
});
