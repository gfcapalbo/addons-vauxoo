# -*- coding: utf-8 -*-
# Copyright 2017 Vauxoo
# License LGPL-3.0 or later (http://www.gnu.org/licenses/lgpl).

from odoo import fields, models


class SaleConfiguration(models.TransientModel):
    _inherit = 'sale.config.settings'

    margin_threshold = fields.Float(
        related='company_id.margin_threshold',
        string=" Margin Threshold")
