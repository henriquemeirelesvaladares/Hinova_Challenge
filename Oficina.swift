//
//  Oficina.swift
//  Hinova_challenge
//
//  Created by Henrique Valadares on 11/06/18.
//  Copyright © 2018 Henrique Valadares. All rights reserved.
//

import Foundation

struct Oficina : Codable{
    var id: Int
    var nome: String
    var descricao: String
    var descricaoCurta: String
    var endereco: String
    var latitude: String
    var longitude: String
    var foto: String
    var avaliacaoUsuario: Int
    var codigoAssociacao: Int
    var email: String
    var telefone1: String
    var telefone2: String
    var ativo: Bool
}
