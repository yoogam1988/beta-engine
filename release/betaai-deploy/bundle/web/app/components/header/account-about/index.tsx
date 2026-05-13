'use client'
import type { LangGeniusVersionResponse } from '@/models/common'
import { RiCloseLine } from '@remixicon/react'
import dayjs from 'dayjs'
import Button from '@/app/components/base/button'
import AtomFlowLogo from '@/app/components/base/logo/atomflow-logo'
import Modal from '@/app/components/base/modal'
import { useGlobalPublicStore } from '@/context/global-public-context'

type IAccountSettingProps = {
  langGeniusVersionInfo: LangGeniusVersionResponse
  onCancel: () => void
}

export default function AccountAbout({
  langGeniusVersionInfo,
  onCancel,
}: IAccountSettingProps) {
  const isLatest = langGeniusVersionInfo.current_version === langGeniusVersionInfo.latest_version
  const systemFeatures = useGlobalPublicStore(s => s.systemFeatures)

  return (
    <Modal
      isShow
      onClose={onCancel}
      className="!w-[480px] !max-w-[480px] !px-6 !py-4"
    >
      <div className="relative">
        <div className="absolute right-0 top-0 flex h-8 w-8 cursor-pointer items-center justify-center" onClick={onCancel}>
          <RiCloseLine className="h-4 w-4 text-text-tertiary" />
        </div>
        <div className="flex flex-col items-center gap-4 py-8">
          {systemFeatures.branding.enabled && systemFeatures.branding.workspace_logo
            ? (
                <img
                  src={systemFeatures.branding.workspace_logo}
                  className="block h-7 w-auto object-contain"
                  alt="logo"
                />
              )
            : <AtomFlowLogo size="large" className="mx-auto" />}

          <div className="text-center text-xs font-normal text-text-tertiary">
            Version
            {langGeniusVersionInfo?.current_version}
          </div>
          <div className="flex flex-col items-center gap-2 text-center text-xs font-normal text-text-secondary">
            <div>Copyright {dayjs().year()} AtomFlow Internal Use.</div>
            <div className="text-text-accent">Internal deployment build</div>
          </div>
        </div>
        <div className="-mx-8 mb-4 h-[0.5px] bg-divider-regular" />
        <div className="flex items-center justify-between gap-4">
          <div className="text-xs font-medium text-text-tertiary">
            {isLatest
              ? `AtomFlow ${langGeniusVersionInfo.latest_version} is the current build.`
              : `New build available: ${langGeniusVersionInfo.latest_version}`}
          </div>
          {!isLatest && (
            <Button variant="primary" size="small" onClick={onCancel}>
              OK
            </Button>
          )}
        </div>
      </div>
    </Modal>
  )
}
