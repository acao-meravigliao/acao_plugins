/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Trailer.Picker', {
  extend: 'Extgui.object.Picker',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Extgui.Ygg.Acao.Trailer',
    'Extgui.Ygg.Acao.Trailer.View',
  ],
  alias: 'widget.acao_trailer_picker',

  extguiObject: 'Extgui.Ygg.Acao.Trailer',

  searchIn: [ 'trailer' ],
  defaultSortField: 'trailer',
  sortFields: [
    { label: 'Identifier', field: 'identifier' },
  ],
});

