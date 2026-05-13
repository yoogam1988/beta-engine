export const isPlatformHost = () => {
  return document.referrer.includes('atomflow')
}

// Backward-compatible export name kept for existing tests and callers.
export const isDify = isPlatformHost
