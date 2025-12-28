# ~/.zshrc

# まず共通設定（今貼ってくれた zshrc の大部分）を読む
if [ -f "$HOME/.zshrc.common" ]; then
  source "$HOME/.zshrc.common"
fi

# プロファイル判定（デフォルトは daily）
: ${ZSH_PROFILE:=daily}

case "$ZSH_PROFILE" in
  shoot)
    [ -f "$HOME/.zshrc.shoot" ] && source "$HOME/.zshrc.shoot"
    ;;
  daily|*)
    [ -f "$HOME/.zshrc.daily" ] && source "$HOME/.zshrc.daily"
    ;;
esac
