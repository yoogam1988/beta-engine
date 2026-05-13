import type { Locale } from '@/i18n-config/language'
import type { DocPathWithoutLang } from '@/types/doc-paths'
import { useTranslation } from '#i18n'
import { useCallback } from 'react'
import { getDocLanguage, getLanguage, getPricingPageLanguage } from '@/i18n-config/language'
import { apiReferencePathTranslations } from '@/types/doc-paths'

export const useLocale = () => {
  const { i18n } = useTranslation()
  return i18n.language as Locale
}

export const useGetLanguage = () => {
  const locale = useLocale()

  return getLanguage(locale)
}
export const useGetPricingPageLanguage = () => {
  const locale = useLocale()

  return getPricingPageLanguage(locale)
}

export const defaultDocBaseUrl = '/help'
export type DocPathMap = Partial<Record<Locale, DocPathWithoutLang>>

export const useDocLink = (baseUrl?: string): ((path?: DocPathWithoutLang, pathMap?: DocPathMap) => string) => {
  let baseDocUrl = baseUrl || defaultDocBaseUrl
  baseDocUrl = (baseDocUrl.endsWith('/')) ? baseDocUrl.slice(0, -1) : baseDocUrl
  const locale = useLocale()
  return useCallback(
    (path?: DocPathWithoutLang, pathMap?: DocPathMap): string => {
      const docLanguage = getDocLanguage(locale)
      const pathUrl = path || ''
      let targetPath = (pathMap) ? pathMap[locale] || pathUrl : pathUrl
      let languagePrefix = `/${docLanguage}`

      // Normalize legacy Dify docs routes to internal help routes.
      if (targetPath === '/use-dify')
        targetPath = '/use'
      else if (targetPath.startsWith('/use-dify/'))
        targetPath = `/use/${targetPath.slice('/use-dify/'.length)}`

      if (targetPath.startsWith('/api-reference/')) {
        languagePrefix = ''
        if (docLanguage !== 'en') {
          const translatedPath = apiReferencePathTranslations[targetPath]?.[docLanguage]
          if (translatedPath) {
            targetPath = translatedPath
          }
        }
      }

      return `${baseDocUrl}${languagePrefix}${targetPath}`
    },
    [baseDocUrl, locale],
  )
}
