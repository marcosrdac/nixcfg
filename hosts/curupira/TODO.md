# Curupira — TODO

## Validação concluída em 2026-10-19

- [x] Migrar a VM OCI ARM64 para configuração declarativa no `nixcfg` (NixOS 26.05, `aarch64-linux`).
- [x] Validar build, `nixos-rebuild test`, `switch` e reboot.
- [x] Confirmar geração ativa após reboot: `/nix/store/w5pdbvx4iic9qjbv70jgvry145mw4hz7-nixos-system-curupira-26.05.20261016.ed583b5`.
- [x] Remover Home Manager e Neovim da configuração mínima deste host, preservando os padrões dos demais hosts.
- [x] Verificar SSH e `dhcpcd` ativos, sem unidades systemd com falha.
- [x] Revisar DHCP IPv4 (`10.0.0.180/24`), gateway (`10.0.0.1`), DNS OCI (`169.254.169.254`) e firewall NixOS.
- [x] Confirmar que a concessão DHCP contém a opção 26 de MTU 9000; a interface `enp0s6` permanece com MTU 1500. Teste IPv4 de 1500 bytes para `1.1.1.1` passou.

## Pendências

- [ ] Revisar a exposição do SSH: regras de ingresso da OCI (VCN/NSG/security lists), restrição de origens e necessidade de acesso público.
- [ ] Revisar `security.sudo.wheelNeedsPassword = false` e definir política de privilégio apropriada.
- [ ] Definir estratégia de backup e recuperação (configuração, dados, volumes e teste de restauração).
- [ ] Investigar MTU 1500 na interface versus MTU 9000 nas rotas DHCP; só testar jumbo frames com procedimento seguro e caminho de recuperação via console OCI. Não alterar a rede apenas para eliminar a diferença.
- [ ] Manter gerações antigas para rollback até a estabilização; decidir posteriormente sobre coleta de lixo do Nix.
- [ ] Revisar as alterações da branch `feat/curupira-nixos-26-05`, abrir/aprovar PR e fazer merge em `main` após a revisão.
- [ ] Depois do merge, atualizar o checkout do Curupira para acompanhar `main` e verificar `nixos-rebuild build --flake .#curupira`.

## Observações

- Gerência de rede: `dhcpcd` em `enp0s6`; não habilitar NetworkManager ou systemd-networkd sem necessidade.
- Firewall NixOS ativo; TCP/22 permitido. A exposição efetiva também depende das regras da OCI.
- Não executar `nix-collect-garbage -d` antes de decidir a política de rollback.
