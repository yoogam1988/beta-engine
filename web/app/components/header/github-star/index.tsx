'use client'
import type { FC } from 'react'

type GithubStarResponse = {
  repo: {
    stars: number
  }
}

const defaultData: GithubStarResponse = {
  repo: { stars: 110918 },
}

const GithubStar: FC<{ className: string }> = (props) => {
  return <span {...props}>{defaultData.repo.stars.toLocaleString()}</span>
}

export default GithubStar
