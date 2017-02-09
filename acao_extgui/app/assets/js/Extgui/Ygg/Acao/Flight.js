/*
 * Copyright (C) 2014-2017, Daniele Orlandi
 *
 * Author:: Daniele Orlandi <daniele@orlandi.com>
 *
 * License:: You can redistribute it and/or modify it under the terms of the LICENSE file.
 *
 */

Ext.define('Extgui.Ygg.Acao.Flight', {
  extend: 'Extgui.object.Base',
  requires: [
    'Extgui.Ygg.Acao.Plugin',
    'Ygg.Acao.Flight',
  ],
  singleton: true,

  subTpl: [
    '<span class="name">{id}</span>',
  ],
});
