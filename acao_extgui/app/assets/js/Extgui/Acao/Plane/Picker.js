/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Plane.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Acao.Plugin',
    'Extgui.Acao.Plane',
    'Extgui.Acao.Plane.View',
    'Extgui.Acao.Plane.Form',
  ],
  alias: 'widget.acao_plane_picker',

  extguiObject: 'Extgui.Acao.Plane',

  searchIn: [ 'registration' ],
  defaultSortField: 'registration',
  sortFields: [
    { label: 'Marche', field: 'registration' },
  ],
});

