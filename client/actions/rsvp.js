export function onResponse() {
  return {type : creators.RESPONDED}
}
export function showConfirmModal() {
  return {type : creators.SHOW_CONFIRM_MODAL}
}

export function hideConfirmModal() {
  return {type : creators.HIDE_CONFIRM_MODAL}
}
export const creators = {
  RESPONDED: "RESPONDED",
  HIDE_CONFIRM_MODAL: "HIDE_CONFIRM_MODAL",
  SHOW_CONFIRM_MODAL: "SHOW_CONFIRM_MODAL",
}