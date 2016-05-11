/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Plane.ReferenceField', {
  extend: 'Extgui.form.field.ReferenceField',
  requires: [
    'Extgui.Acao.Plugin',
    'Ygg.Acao.Plane',
    'Extgui.Acao.Plane',
    'Extgui.Acao.Plane.Picker',
  ],
  alias: 'widget.acao_plane',

  extguiObject: 'Extgui.Acao.Plane',
  pickerClass: 'Extgui.Acao.Plane.Picker',
});
