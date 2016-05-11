/*
 * Copyright (C) 2014-2014, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Acao.Flight', {
  extend: 'Extgui.object.Base',
  requires: [
    'Extgui.Acao.Plugin',
  ],
  singleton: true,

  model: 'Ygg.Acao.Flight',

  subTpl: [
    '<span class="name">{id}</span>',
  ],
});
